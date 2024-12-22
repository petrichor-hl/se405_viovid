import 'package:flutter/material.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/payment_history/dtos/payment_record.dart';

class PaymentRecordItem extends StatelessWidget {
  const PaymentRecordItem({
    super.key,
    required this.record,
  });

  final PaymentRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        bottom: 6,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.commit_rounded,
                color: Colors.amber,
              ),
              Expanded(
                child: Text(
                  record.paymentId,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.abc,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'Đăng ký ${record.planName}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (record.isDone)
            Row(
              spacing: 8,
              children: [
                const Icon(
                  Icons.price_change,
                  color: Colors.white,
                ),
                Text(
                  record.amount!.toVnCurrencyFormat(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (record.isDone)
            Row(
              spacing: 8,
              children: [
                const Icon(
                  Icons.start_rounded,
                  color: Colors.white,
                ),
                Text(
                  'Bắt đầu: ${record.startDate!.toVnFormat()}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (record.isDone)
            Row(
              spacing: 8,
              children: [
                const Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                ),
                Text(
                  'Kết thúc: ${record.endDate!.toVnFormat()}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: record.isDone ? Colors.green : Colors.red,
            ),
            child: Text(
              record.isDone ? "Thành Công" : "Không thành không",
              style: const TextStyle(
                // fontSize: 16,
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
