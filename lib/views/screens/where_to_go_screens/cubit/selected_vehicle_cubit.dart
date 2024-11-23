import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'selected_vehicle_state.dart';

class SelectedVehicleCubit extends Cubit<SelectedVehicleState> {
  SelectedVehicleCubit() : super(SelectedVehicleInitial());
  void loadVehicle(Map<String, dynamic> vehicle) {
    emit(VehicleLoading());
    // Simulate a delay for loading (e.g., fetching from a database or API)
    Future.delayed(Duration(seconds: 1), () {
      emit(VehicleLoaded(vehicle));
    });
  }
}
