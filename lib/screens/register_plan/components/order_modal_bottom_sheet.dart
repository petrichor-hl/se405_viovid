import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/features/payment/data/payment_api_service.dart';
import 'package:viovid_app/features/payment/data/payment_repository.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';
import 'package:viovid_app/features/result_type.dart';

final _paymentMethods = [
  {
    'name': 'VNPAY',
    'logo': Assets.vnPayLogo,
  },
  {
    'name': 'Stripe',
    'logo': Assets.stripeLogo,
  },
  // {
  //   'name': 'Momo',
  //   'logo': Assets.momoLogo,
  // }
];

class OrderModalBottomSheet extends StatefulWidget {
  const OrderModalBottomSheet({
    super.key,
    required this.plan,
  });

  final Plan plan;

  @override
  State<OrderModalBottomSheet> createState() => _OrderModalBottomSheetState();
}

class _OrderModalBottomSheetState extends State<OrderModalBottomSheet> {
  bool isLoading = false;

  void handlePayment(String paymentType) async {
    log('Pay with $paymentType');

    final paymentRepo = PaymentRepository(
      paymentApiService: PaymentApiService(dio),
    );

    switch (paymentType) {
      case 'VNPAY':
        setState(() {
          isLoading = true;
        });
        final result = await paymentRepo.getPaymentUrl(widget.plan.id);
        if (result is Success<String>) {
          final paymentUrl = (result as Success).data;
          final uri = Uri.parse(paymentUrl);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppWebView);
          }
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (ctx) => PaymentWebView(
          //       paymentUrl: paymentUrl,
          //     ),
          //   ),
          // );
        } else {
          // TODO: show Error dialog
        }
        setState(() {
          isLoading = false;
        });
        break;
      case 'Stripe':
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            width: double.infinity,
            height: 300, // Sử dụng tỷ lệ nếu cần
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _buildModalBottomSheet();
  }

  Widget _buildModalBottomSheet() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Text(
              'Thông tin gói:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.all(20),
            color: Colors.amber.shade300,
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.indigo,
                  ),
                  child: Text(
                    widget.plan.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '- Giá ${widget.plan.price.toVnCurrencyFormat()}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '- Bắt đầu: ${DateTime.now().toVnFormat()}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '- Kết thúc: ${DateTime.now().add(Duration(days: widget.plan.duration)).toVnFormat()}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              'Chọn phương thức thanh toán:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: _paymentMethods.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (ctx, index) => InkWell(
              onTap: () => handlePayment(_paymentMethods[index]['name']!),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        _paymentMethods[index]['logo']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      _paymentMethods[index]['name']!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black45,
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.black12,
                height: 12,
              );
            },
          )
        ],
      ),
    );
  }
}
