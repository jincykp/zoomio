import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:zoomer/model/vehicle_model.dart';
import 'package:zoomer/views/screens/where_to_go_screens/price_services.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final PriceServices priceServices;

  VehicleBloc(this.priceServices) : super(VehicleLoadingState()) {
    on<CalculatePricesEvent>(_onCalculatePrices);
    on<FetchVehiclesEvent>(_onFetchVehicles);
  }

  Future<void> _onCalculatePrices(
    CalculatePricesEvent event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      // Calculate prices for available vehicles
      List<Map<String, dynamic>> totalPriceList =
          await priceServices.calculateTotalPriceForAllVehicles(
        event.distanceInKilometers,
      );

      if (totalPriceList.isEmpty) {
        emit(VehicleErrorState('No available vehicles found'));
        return;
      }

      emit(VehiclePriceCalculatedState(totalPriceList));
    } catch (error) {
      emit(VehicleErrorState('Failed to calculate prices: $error'));
    }
  }

  Future<void> _onFetchVehicles(
    FetchVehiclesEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoadingState());
    try {
      final QuerySnapshot vehicleSnapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .where('status', isEqualTo: 'available')
          .get();

      if (vehicleSnapshot.docs.isEmpty) {
        emit(VehicleErrorState('No available vehicles found'));
        return;
      }

      final List<Map<String, dynamic>> availableVehicles = vehicleSnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();

      emit(VehiclesFetchedState(availableVehicles));
    } catch (error) {
      emit(VehicleErrorState('Failed to fetch vehicles: $error'));
    }
  }
}
