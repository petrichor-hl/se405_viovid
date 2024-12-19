part of 'payment_history_cubit.dart';

sealed class PaymentHistoryState {}

class PaymentHistoryInProgress extends PaymentHistoryState {}

class PaymentHistorySuccess extends PaymentHistoryState {
  final List<PaymentRecord> paymentRecords;

  PaymentHistorySuccess(this.paymentRecords);
}

class PaymentHistoryFailure extends PaymentHistoryState {
  final String message;

  PaymentHistoryFailure(this.message);
}
