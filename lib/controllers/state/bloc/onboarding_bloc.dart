import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int totalPages; // Declare the totalPages variable

  OnboardingBloc({required this.totalPages}) : super(OnboardingInitial()) {
    // Initialize the onboarding flow
    on<NextPageEvent>((event, emit) {
      if (state is OnboardingInProgress) {
        final currentState = state as OnboardingInProgress;
        if (currentState.currentPage < totalPages - 1) {
          emit(OnboardingInProgress(currentState.currentPage + 1));
        } else {
          emit(OnboardingComplete());
        }
      }
    });

    on<PreviousPageEvent>((event, emit) {
      if (state is OnboardingInProgress) {
        final currentState = state as OnboardingInProgress;
        if (currentState.currentPage > 0) {
          emit(OnboardingInProgress(currentState.currentPage - 1));
        }
      }
    });

    // Start the onboarding flow with the first page
    emit(OnboardingInProgress(0));
  }
}
