import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_state.dart';
import 'package:viovid_app/screens/auth/sign_in.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  String? errorMessage;

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate() ||
        _newPasswordController.text != _confirmedPasswordController.text) {
      setState(() {
        errorMessage = 'Xác nhận mật khẩu không khớp.';
      });
      return;
    }

    context.read<UserProfileCubit>().changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi Mật Khẩu'),
      ),
      body: BlocListener<UserProfileCubit, UserProfileState>(
        listenWhen: (previous, current) =>
            current.isLoadingChangePassword == false,
        listener: (ctx, state) {
          if (state.isLoadingChangePassword == false &&
              state.errorMessage != null) {
            setState(() {
              errorMessage = state.errorMessage!;
            });
          }

          if (state.isLoadingChangePassword == false &&
              state.errorMessage == null) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thay đổi mật khẩu Thành công!'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(
              const Duration(milliseconds: 500),
              // ignore: use_build_context_synchronously
              () => context.pop(),
            );
          }
        },
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (ctx, state) {
            return state.isLoadingChangePassword
                ? _buildInProgressChangePasswordlWidget()
                : _buildChangePasswordWidget();
          },
        ),
      ),
    );
  }

  Widget _buildInProgressChangePasswordlWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Gap(14),
          Text(
            'Đang xử lý',
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

  Widget _buildChangePasswordWidget() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(20),
            PasswordTextField(
              passwordController: _currentPasswordController,
              hintText: 'Mật khẩu hiện tại',
            ),
            const Divider(
              height: 30,
              indent: 70,
              endIndent: 70,
              color: Colors.grey,
            ),
            PasswordTextField(
              passwordController: _newPasswordController,
              hintText: 'Mật khẩu mới',
            ),
            const Gap(12),
            PasswordTextField(
              passwordController: _confirmedPasswordController,
              hintText: 'Xác nhận mật khẩu mới',
            ),
            const Gap(30),
            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _submit(context),
                child: const Text(
                  'LƯU',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
