import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/screens/film_detail/components/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInState();
}

class _SignInState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameControllber = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUpAccount() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final enteredUsername = _nameControllber.text;
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;

    context.read<AuthBloc>().add(
          AuthRegisterStarted(
            name: enteredUsername,
            email: enteredEmail,
            password: enteredPassword,
          ),
        );
  }

  @override
  void dispose() {
    _nameControllber.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthRegisterSuccess || current is AuthRegisterFailure,
      listener: (context, state) {
        switch (state) {
          case AuthRegisterSuccess():
            showDialog(
              context: context,
              builder: (ctx) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                surfaceTintColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 60,
                      ),
                      const Gap(8),
                      const Text(
                        'Đăng ký thành công!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          // color: Colors.white,
                        ),
                      ),
                      const Gap(12),
                      const Text(
                        'Vui lòng xác thực Email trong Hộp thư đến.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: Colors.white,
                        ),
                      ),
                      const Gap(20),
                      FilledButton(
                        onPressed: () {
                          // TODO quay về trang SIGN IN
                        },
                        child: const Text(
                          'Đã hiểu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
            break;
          case AuthRegisterFailure():
            showDialog(
              context: context,
              builder: (ctx) => ErrorDialog(errorMessage: state.message),
            );
            break;
          default:
            break;
        }
      },
      buildWhen: (previous, current) =>
          current is AuthRegisterInProgress ||
          current is AuthRegisterSuccess ||
          current is AuthRegisterFailure,
      builder: (context, state) {
        var registerWiget = (switch (state) {
          AuthRegisterInProgress() => _buildInProgressRegisterWidget(),
          _ => _buildRegisterWidget(),
        });

        return registerWiget;
      },
    );
  }

  Widget _buildInProgressRegisterWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Gap(14),
        Text(
          'Đang đăng ký tài khoản',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(50),
      ],
    );
  }

  Widget _buildRegisterWidget() {
    final screenSize = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(screenSize.height * 0.07),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://kpaxjjmelbqpllxenpxz.supabase.co/storage/v1/object/public/avatar/default_avt.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.image_rounded,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const Gap(8),
              const Text(
                'Sau khi đăng nhập\nBạn có thể thay đổi Ảnh đại diện.',
                style: TextStyle(
                  color: Color(0xFFACACAC),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              TextFormField(
                controller: _nameControllber,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 51, 51, 51),
                  hintText: 'Tên của bạn',
                  hintStyle: TextStyle(color: Color(0xFFACACAC)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  errorStyle: TextStyle(fontSize: 14),
                ),
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false, // No work+
                keyboardType:
                    TextInputType.emailAddress, // Trick: disable suggestions
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập Tên';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 51, 51, 51),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Color(0xFFACACAC)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  errorStyle: TextStyle(fontSize: 14),
                ),
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false, // No work
                keyboardType:
                    TextInputType.emailAddress, // Trick: disable suggestions
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập Email';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              _PasswordTextFormField(passwordController: _passwordController),
              const Gap(50),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _signUpAccount,
                  child: const Text(
                    'ĐĂNG KÝ',
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordTextFormField extends StatefulWidget {
  const _PasswordTextFormField({required this.passwordController});
  final TextEditingController passwordController;

  @override
  State<_PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<_PasswordTextFormField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 51, 51, 51),
        hintText: 'Mật khẩu',
        hintStyle: const TextStyle(color: Color(0xFFACACAC)),
        suffixIcon: widget.passwordController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isShowPassword = !_isShowPassword;
                  });
                },
                icon: _isShowPassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
        suffixIconColor: const Color(0xFFACACAC),
        errorStyle: const TextStyle(fontSize: 14),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      ),
      obscureText: !_isShowPassword,
      style: const TextStyle(color: Colors.white),
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bạn chưa nhập Mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu gồm 6 ký tự trở lên.';
        }
        return null;
      },
      onChanged: (value) {
        if (value.isEmpty) {
          _isShowPassword = false;
        }

        if (value.length <= 1) setState(() {});
      },
    );
  }
}
