import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/payment_history/cubit/payment_history_cubit.dart';
import 'package:viovid_app/features/payment_history/dtos/payment_record.dart';
import 'package:viovid_app/screens/main/profile/components/payment_record_item.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentHistoryCubit>().getPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    final paymentHistoryState = context.watch<PaymentHistoryCubit>().state;

    var paymentHistoryWidget = (switch (paymentHistoryState) {
      PaymentHistoryInProgress() => _buildInProgressPaymentHistoryWidget(),
      PaymentHistorySuccess() =>
        _buildPaymentHistoryWidget(paymentHistoryState.paymentRecords),
      PaymentHistoryFailure() =>
        _buildFailurePaymentHistoryWidget(paymentHistoryState.message),
    });

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop()
            ? null
            : IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () => context.go(RouteName.bottomNav),
              ),
        title: const Text('Lịch sử thanh toán'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: paymentHistoryWidget,
    );
  }

  Widget _buildInProgressPaymentHistoryWidget() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (ctx, index) => const SkeletonLoading(height: 148),
      itemCount: 5,
      separatorBuilder: (context, index) => const Gap(12),
    );
  }

  Widget _buildPaymentHistoryWidget(List<PaymentRecord> paymentRecords) {
    return paymentRecords.isEmpty
        ? const Center(
            child: Text(
              'Bạn chưa thực hiện\nthanh toán nào.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (ctx, index) => PaymentRecordItem(
              record: paymentRecords[index],
            ),
            itemCount: paymentRecords.length,
            separatorBuilder: (context, index) => const Gap(12),
          );
  }

  Widget _buildFailurePaymentHistoryWidget(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Có lỗi xảy ra:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
