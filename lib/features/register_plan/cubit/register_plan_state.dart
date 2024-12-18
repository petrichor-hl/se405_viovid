part of 'register_plan_cubit.dart';

sealed class RegisterPlanState {}

class RegisterPlanInProgress extends RegisterPlanState {}

class RegisterPlanSuccess extends RegisterPlanState {
  final List<Plan> plans;

  RegisterPlanSuccess(this.plans);
}

class RegisterPlanFailure extends RegisterPlanState {
  final String message;

  RegisterPlanFailure(this.message);
}
