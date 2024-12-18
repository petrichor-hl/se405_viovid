import 'package:viovid_app/features/register_plan/data/register_plan_api_service.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';
import 'package:viovid_app/features/result_type.dart';

class RegisterPlanRepository {
  final RegisterPlanApiService registerPlanApiService;

  RegisterPlanRepository({
    required this.registerPlanApiService,
  });

  Future<Result<List<Plan>>> getListPlan() async {
    try {
      return Success(await registerPlanApiService.getListPlan());
    } catch (error) {
      return Failure('$error');
    }
  }
}
