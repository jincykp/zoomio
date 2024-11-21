part of 'selected_vehicle_bloc.dart';

sealed class SelectedVehicleEvent extends Equatable {
  const SelectedVehicleEvent();

  @override
  List<Object> get props => [];
}

class SelectVehicleEvent extends SelectedVehicleEvent {
  final Vehicle vehicle;

  SelectVehicleEvent(this.vehicle);
}

class DeselectVehicleEvent extends SelectedVehicleEvent {}
