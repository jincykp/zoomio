import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomer/model/vehicle_model.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetching all the vehicles from Firestore
  Future<List<Vehicle>> fetchVehicles() async {
    try {
      // Getting all the documents from the 'Vehicles' collection
      final querySnapshot = await _firestore.collection('Vehicles').get();

      // Mapping the documents to Vehicle objects
      return querySnapshot.docs.map((doc) {
        return Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching vehicles: $e');
      return [];
    }
  }
}
