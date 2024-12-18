import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';

final _paymentMethods = [
  {
    'name': 'VNPAY',
    'logo': Assets.vnPayLogo,
  },
  {
    'name': 'Stripe',
    'logo': Assets.stripeLogo,
  },
  {
    'name': 'Momo',
    'logo': Assets.momoLogo,
  }
];

class PlanItem extends StatelessWidget {
  const PlanItem({
    super.key,
    required this.plan,
  });

  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCC191C21),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.name,
                style: TextStyle(
                  fontSize: 24,
                  color: plan.name == 'Thường'
                      ? const Color(0xFF949AA4)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              plan.name == 'Thường'
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF949AA4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        child: Text(
                          'Đang sử dụng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF949AA4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : FilledButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.grey.shade100,
                          builder: (ctx) {
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
                                    // color: const Color(0xFFFFE7E8),
                                    color: Colors.amber.shade300,
                                    child: Column(
                                      spacing: 6,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.indigo,
                                          ),
                                          child: Text(
                                            plan.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '- Giá ${plan.price.toVnCurrencyFormat()}',
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
                                          '- Kết thúc: ${DateTime.now().add(Duration(days: plan.duration)).toVnFormat()}',
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
                                      onTap: () {},
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                          },
                        );
                      },
                      child: const Text(
                        'Chọn',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.price_change,
                color: Colors.white,
              ),
              Text(
                '- ${plan.name == 'Thường' ? 'Miễn phí' : plan.price.toVnCurrencyFormat()}',
                style: TextStyle(
                  fontSize: 16,
                  color: plan.name == 'Thường'
                      ? const Color(0xFF949AA4)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              const Icon(
                Icons.timelapse,
                color: Colors.white,
              ),
              Text(
                '- ${plan.name == 'Thường' ? 'Vĩnh viễn' : '${plan.duration} ngày'}',
                style: TextStyle(
                  fontSize: 16,
                  color: plan.name == 'Thường'
                      ? const Color(0xFF949AA4)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
