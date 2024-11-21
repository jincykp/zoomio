import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zoomer/model/vehicle_model.dart';

part 'selected_vehicle_event.dart';
part 'selected_vehicle_state.dart';

class SelectedVehicleBloc
    extends Bloc<SelectedVehicleEvent, SelectedVehicleState> {
  SelectedVehicleBloc() : super(VehicleInitialState());

  @override
  Stream<SelectedVehicleState> mapEventToState(
      SelectedVehicleEvent event) async* {
    if (event is SelectVehicleEvent) {
      yield VehicleSelectedState(event.vehicle); // Emit selected vehicle state
    } else if (event is DeselectVehicleEvent) {
      yield VehicleDeselectedState(); // Emit deselected state
    }
  }
}
