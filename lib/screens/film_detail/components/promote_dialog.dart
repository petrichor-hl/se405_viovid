import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PromoteDialog extends StatelessWidget {
  const PromoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        surfaceTintColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.rubySparkles,
                width: 100,
                height: 100,
              ),
              const Gap(8),
              const Text(
                'THÔNG TIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  // color: Colors.white,
                ),
              ),
              const Gap(12),
              const Text(
                'Bạn cần tài khoản trả phí để có thể xem nội dung này.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  // color: Colors.white,
                ),
              ),
              const Gap(20),
              orientation == Orientation.portrait
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            context.pop();
                            await context.push(RouteName.registerPlan);
                          },
                          child: const Text(
                            'Nâng cấp Premium',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Gap(20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Bỏ qua",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton(
                          onPressed: () async {
                            context.pop();
                            WakelockPlus.disable();
                            // try {
                            //   ScreenBrightness()
                            //       .resetApplicationScreenBrightness();
                            // } catch (e) {
                            //   //
                            // }
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.portraitUp,
                            ]);
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.edgeToEdge);
                            await context.push(RouteName.registerPlan);

                            WakelockPlus.enable();

                            // try {
                            //   ScreenBrightness()
                            //       .setApplicationScreenBrightness(1);
                            // } catch (e) {
                            //   //
                            // }

                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight,
                            ]);
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.immersiveSticky);
                          },
                          child: const Text(
                            'Nâng cấp Premium',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Gap(20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Bỏ qua",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ));
  }
}
