import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/payment_history/data/payment_history_repository.dart';
import 'package:viovid_app/features/payment_history/dtos/payment_record.dart';
import 'package:viovid_app/features/result_type.dart';

part 'payment_history_state.dart';

// Cubit + Repository
class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  final PaymentHistoryRepository _paymentHistoryRepository;

  PaymentHistoryCubit(this._paymentHistoryRepository)
      : super(PaymentHistoryInProgress());

  Future<void> getPaymentHistory() async {
    final result = await _paymentHistoryRepository.getPaymentHistory();
    return (switch (result) {
      Success() => emit(PaymentHistorySuccess(result.data)),
      Failure() => emit(PaymentHistoryFailure(result.message)),
    });
  }
}
