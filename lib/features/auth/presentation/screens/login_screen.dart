import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<LoginCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFF8FAFC), Color(0xFFE8EEF9)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  elevation: 10,
                  shadowColor: AppColors.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.p32),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: BlocConsumer<LoginCubit, LoginState>(
                          listenWhen: (previous, current) =>
                              current is LoginFailure,
                          listener: (context, state) {
                            if (state case LoginFailure(:final message)) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                            }
                          },
                          builder: (context, state) {
                            final isSubmitting = state is LoginSubmitting;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _LoginHeader(),
                                SizedBox(height: AppSizes.h32),
                                CustomTextField(
                                  label: AppStrings.email,
                                  hint: AppStrings.emailHint,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.username,
                                    AutofillHints.email,
                                  ],
                                  prefixIcon: Icons.alternate_email_rounded,
                                  enabled: !isSubmitting,
                                  validator: (value) {
                                    final email = value?.trim() ?? '';
                                    if (email.isEmpty ||
                                        !email.contains('@') ||
                                        !email.split('@').last.contains('.')) {
                                      return AppStrings.invalidEmail;
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    _passwordFocusNode.requestFocus();
                                  },
                                ),
                                SizedBox(height: AppSizes.h20),
                                CustomTextField(
                                  label: AppStrings.password,
                                  hint: AppStrings.passwordHint,
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  enabled: !isSubmitting,
                                  suffixIcon: IconButton(
                                    tooltip: _obscurePassword
                                        ? AppStrings.showPassword
                                        : AppStrings.hidePassword,
                                    onPressed: isSubmitting
                                        ? null
                                        : () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppStrings.passwordRequired;
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                                SizedBox(height: AppSizes.h24),
                                CustomButton(
                                  key: const Key('login-submit'),
                                  text: AppStrings.signIn,
                                  icon: Icons.login_rounded,
                                  isLoading: isSubmitting,
                                  onPressed: _submit,
                                ),
                                SizedBox(height: AppSizes.h16),
                                Text(
                                  AppStrings.authorizedUsersOnly,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.r16),
          ),
          child: const Icon(
            Icons.warehouse_rounded,
            color: AppColors.surface,
            size: 40,
          ),
        ),
        SizedBox(height: AppSizes.h20),
        Text(
          AppStrings.appTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSizes.h8),
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
