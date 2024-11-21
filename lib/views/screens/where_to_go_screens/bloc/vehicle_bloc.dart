import 'package:bloc/bloc.dart';
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

  void _onCalculatePrices(
      CalculatePricesEvent event, Emitter<VehicleState> emit) async {
    try {
      List<Map<String, dynamic>> totalPriceList = await priceServices
          .calculateTotalPriceForAllVehicles(event.distanceInKilometers);
      emit(VehiclePriceCalculatedState(totalPriceList));
    } catch (error) {
      emit(VehicleErrorState('Failed to calculate prices: $error'));
    }
  }

  void _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<VehicleState> emit) async {
    emit(VehicleLoadingState());
    // Fetch vehicle data logic if required
  }
}
