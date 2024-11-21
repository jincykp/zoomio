import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'where_to_go_event.dart';
part 'where_to_go_state.dart';

class WhereToGoBloc extends Bloc<WhereToGoEvent, WhereToGoState> {
  WhereToGoBloc() : super(WhereToGoInitial()) {
    on<WhereToGoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
