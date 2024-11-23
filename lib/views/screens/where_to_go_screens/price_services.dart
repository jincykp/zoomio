import 'package:cloud_firestore/cloud_firestore.dart';

class PriceServices {
  /// Calculate the total price for all vehicles based on distance
  Future<List<Map<String, dynamic>>> calculateTotalPriceForAllVehicles(
      double distanceInKilometers) async {
    try {
      // Fetch all vehicle rates from Firestore
      List<Map<String, dynamic>> allRates = await fetchAllVehicleRates();

      // Initialize a list to store the total prices for all vehicles
      List<Map<String, dynamic>> totalPriceList = [];

      for (var rates in allRates) {
        // Extract rates for each vehicle
        double baseFare = (rates['baseFare'] ?? 0.0).toDouble();
        double perKilometerCharge =
            (rates['perKilometerCharge'] ?? 0.0).toDouble();
        double waitingCharge = (rates['waitingCharge'] ?? 0.0).toDouble();

        // Debug: Log the rates being processed
        print("Processing Vehicle: ${rates['vehicleType']}");
        print(
            "Base Fare: ₹$baseFare, Per KM Charge: ₹$perKilometerCharge, Waiting Charge: ₹$waitingCharge");

        // Calculate the total price for the vehicle
        double totalPrice = baseFare +
            (distanceInKilometers * perKilometerCharge) +
            waitingCharge;

        // Add the total price and vehicle data to the result list
        totalPriceList.add({
          'vehicleType': rates['vehicleType'],
          'brand': rates['brand'], // Ensure 'brand' exists in Firestore
          'seatingCapacity':
              rates['seatingCapacity'], // Ensure 'seatingCapacity' exists
          'aboutVehicle': rates['aboutVehicle'] ??
              'No description available', // Add description
          'totalPrice': totalPrice, // Calculated total price
        });
      }

      return totalPriceList;
    } catch (e) {
      print("Error calculating total price for all vehicles: $e");
      return [];
    }
  }

  /// Fetch all vehicle rates from Firestore
  Future<List<Map<String, dynamic>>> fetchAllVehicleRates() async {
    try {
      // Fetch all documents from the 'vehicles' Firestore collection
      var snapshot =
          await FirebaseFirestore.instance.collection('vehicles').get();

      // Check if the snapshot is empty
      if (snapshot.docs.isEmpty) {
        print("No vehicle rates found");
        throw Exception("No vehicle rates found");
      }

      // Convert snapshot documents to a list of maps
      List<Map<String, dynamic>> ratesList = snapshot.docs.map((doc) {
        // Debug: Log the data fetched from Firestore
        print("Fetched data: ${doc.data()}");
        return doc.data();
      }).toList();

      return ratesList;
    } catch (e) {
      print("Error fetching vehicle rates: $e");
      rethrow; // Rethrow to propagate the error
    }
  }
}
