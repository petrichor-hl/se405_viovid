import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/register_plan/data/register_plan_repository.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';
import 'package:viovid_app/features/result_type.dart';

part 'register_plan_state.dart';

class RegisterPlanCubit extends Cubit<RegisterPlanState> {
  final RegisterPlanRepository _registerPlanRepository;

  RegisterPlanCubit(this._registerPlanRepository)
      : super(RegisterPlanInProgress());

  void getListPlan() async {
    final result = await _registerPlanRepository.getListPlan();
    switch (result) {
      case Success():
        result.data.insert(
          0,
          Plan(id: 'Normal', name: 'Thường', price: 0, duration: 0, order: -1),
        );
        emit(RegisterPlanSuccess(result.data));
        break;
      case Failure():
        emit(RegisterPlanFailure(result.message));
        break;
    }
    ;
  }
}
