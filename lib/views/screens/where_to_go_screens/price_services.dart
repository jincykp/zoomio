import 'package:cloud_firestore/cloud_firestore.dart';

class PriceServices {
  Future<List<Map<String, dynamic>>> calculateTotalPriceForAllVehicles(
      double distanceInKilometers) async {
    try {
      // Fetch all vehicle rates from Firestore
      List<Map<String, dynamic>> allRates = await fetchAllVehicleRates();

      // Calculate total price for each vehicle
      List<Map<String, dynamic>> totalPriceList = [];

      for (var rates in allRates) {
        // Extract rates for each vehicle
        double baseFare = rates['baseFare'] ?? 0.0;
        double perKilometerCharge = rates['perKilometerCharge'] ?? 0.0;
        double waitingCharge = rates['waitingCharge'] ?? 0.0;

        // Calculate the total price for each vehicle
        double totalPrice = baseFare +
            (distanceInKilometers * perKilometerCharge) +
            waitingCharge;

        // Add the calculated total price to the result list
        totalPriceList.add({
          'vehicleType': rates['vehicleType'],
          'totalPrice': totalPrice,
        });
      }

      return totalPriceList;
    } catch (e) {
      print("Error calculating total price for all vehicles: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllVehicleRates() async {
    try {
      // Query all vehicles in the Firestore collection
      var snapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .get(); // No filtering by vehicle type, fetching all vehicles

      if (snapshot.docs.isEmpty) {
        print("No vehicle rates found");
        throw Exception("No vehicle rates found");
      }

      // Extract vehicle data
      List<Map<String, dynamic>> ratesList = snapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      return ratesList;
    } catch (e) {
      print("Error fetching vehicle rates: $e");
      rethrow; // Rethrow the error for handling in the calling function
    }
  }
}
