part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

final class NextPageEvent extends OnboardingEvent {}

final class PreviousPageEvent extends OnboardingEvent {}
