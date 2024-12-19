import 'package:flutter/material.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';
import 'package:viovid_app/screens/register_plan/components/order_modal_bottom_sheet.dart';

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
                            return OrderModalBottomSheet(
                              plan: plan,
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
