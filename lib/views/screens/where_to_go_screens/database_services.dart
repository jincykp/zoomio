import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomer/model/vehicle_model.dart';

class DatabaseServices {
  Future<List<Vehicle>> getVehicles() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('vehicles').get();

      // Map each document to a Vehicle object
      return querySnapshot.docs.map((doc) {
        return Vehicle.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load vehicles: $e');
    }
  }
}
