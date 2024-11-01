part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingInProgress extends OnboardingState {
  final int currentPage;

  OnboardingInProgress(this.currentPage);
}

final class OnboardingComplete extends OnboardingState {}
