import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/features/register_plan/cubit/register_plan_cubit.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';
import 'package:viovid_app/screens/register_plan/components/plan_item.dart';

class RegisterPlanScreen extends StatefulWidget {
  const RegisterPlanScreen({super.key});

  @override
  State<RegisterPlanScreen> createState() => _RegisterPlanScreenState();
}

class _RegisterPlanScreenState extends State<RegisterPlanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RegisterPlanCubit>().getListPlan();
  }

  @override
  Widget build(BuildContext context) {
    final registerPlanState = context.watch<RegisterPlanCubit>().state;

    var registerPlanWidget = (switch (registerPlanState) {
      RegisterPlanInProgress() => _buildInProgressRegisterPlanWidget(),
      RegisterPlanSuccess() =>
        _buildRegisterPlanWidget(registerPlanState.plans),
      RegisterPlanFailure() =>
        _buildFailureRegisterPlanWidget(registerPlanState.message),
    });

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Assets.viovidLogo,
          width: 120,
        ),
      ),
      body: registerPlanWidget,
    );
  }

  Widget _buildInProgressRegisterPlanWidget() {
    return const Center(
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text(
            'Đang tải dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPlanWidget(List<Plan> plans) {
    return Column(
      children: [
        const Gap(10),
        const Text(
          'Các gói dịch vụ và mức giá',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: List.generate(
              plans.length,
              (index) => PlanItem(
                plan: plans[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailureRegisterPlanWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
