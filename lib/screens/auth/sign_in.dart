import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/config/styles.config.dart';
import 'package:viovid_app/features/auth/bloc/auth_bloc.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<SignInScreen> createState() => _SignInState();
}

class _SignInState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
      TextEditingController(text: 'dexapev126@rowplant.com');
  final _passwordController = TextEditingController(text: 'dexapev126');

  void _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          AuthLoginStarted(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) async {
        if (state is AuthLoginSuccess) {
          await ctx.read<UserProfileCubit>().getUserProfile();
          await ctx.read<UserProfileCubit>().getTrackingProgress();
          await ctx.read<MyListCubit>().getMyList();
          ctx.go(RouteName.bottomNav);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) =>
            current is AuthLoginInProgress || current is AuthLoginFailure,
        builder: (ctx, state) {
          var loginWiget = (switch (state) {
            AuthUnauthenticated() => _buildLoginWidget(),
            AuthLoginInProgress() => _buildInProgressLoginWidget(),
            AuthLoginFailure() =>
              _buildLoginWidget(errorMessage: state.message),
            _ => const SizedBox(),
          });

          return loginWiget;
        },
      ),
    );
  }

  Widget _buildInProgressLoginWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Gap(14),
        Text(
          'Đang đăng nhập',
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

  Widget _buildLoginWidget({String? errorMessage}) {
    return Align(
      alignment: const Alignment(0, -0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  errorStyle: TextStyle(
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                ),
                style: const TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false, // No work
                keyboardType:
                    TextInputType.emailAddress, // Trick: disable suggestions
                validator: (value) {
                  // print('Value = $value');
                  if (value == null || value.isEmpty) {
                    return 'Bạn chưa nhập Email';
                  }
                  return null;
                },
              ),
              const Gap(12),
              PasswordTextField(passwordController: _passwordController),
              const Gap(20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _submit(context),
                  child: const Text(
                    'ĐĂNG NHẬP',
                  ),
                ),
              ),
              const Gap(16),
              if (errorMessage != null)
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              const Gap(30),
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(AuthLogout());
                },
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Khôi phục mật khẩu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Gap(12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bạn chưa có tài khoản? ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.hintText,
    required this.passwordController,
  });

  final String? hintText;
  final TextEditingController passwordController;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 51, 51, 51),
        hintText: widget.hintText ?? 'Mật khẩu',
        hintStyle: const TextStyle(color: Color(0xFFACACAC)),
        errorStyle: const TextStyle(
          fontSize: 14,
        ),
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
