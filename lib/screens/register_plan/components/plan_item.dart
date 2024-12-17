import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';

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
                      onPressed: () {},
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
      // child: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      // Text(
      //   plan.name,
      //   style: TextStyle(
      //     fontSize: 28,
      //     color: plan.name == 'Thường'
      //         ? const Color(0xFF949AA4)
      //         : Colors.white,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      //           const Gap(30),
      //           plan.name == 'Thường'
      // ? DecoratedBox(
      //     decoration: BoxDecoration(
      //       border: Border.all(
      //         color: const Color(0xFF949AA4),
      //       ),
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     child: const Padding(
      //       padding: EdgeInsets.symmetric(
      //           vertical: 10, horizontal: 14),
      //       child: Text(
      //         'Đang sử dụng',
      //         style: TextStyle(
      //           fontSize: 16,
      //           color: Color(0xFF949AA4),
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ),
      //   )
      // : FilledButton(
      //     onPressed: () {},
      //     child: const Text(
      //       'Chọn',
      //       style: TextStyle(
      //         fontSize: 16,
      //         color: Colors.white,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      //           const Gap(40),
      // Text(
      //   plan.name == 'Thường'
      //       ? 'Miễn phí'
      //       : plan.price.toVnCurrencyFormat(),
      //   style: TextStyle(
      //     fontSize: 18,
      //     color: plan.name == 'Thường'
      //         ? const Color(0xFF949AA4)
      //         : Colors.white,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      //           const Gap(20),
      // Text(
      //   plan.name == 'Thường' ? '' : '${plan.duration} ngày',
      //   style: const TextStyle(
      //     fontSize: 18,
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      //         ],
      //       ),
      //     ),
      //     if (plan.name == 'PRO')
      //       Positioned(
      //         top: 0,
      //         left: 0,
      //         right: 0,
      //         child: Align(
      //           alignment: Alignment.topCenter,
      //           child: Transform.translate(
      //             offset: const Offset(0, -16),
      //             child: DecoratedBox(
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(50),
      //               ),
      //               child: const Padding(
      //                 padding:
      //                     EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      //                 child: Text(
      //                   'Khuyên dùng',
      //                   style: TextStyle(
      //                     fontSize: 16,
      //                     color: Colors.black,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}
