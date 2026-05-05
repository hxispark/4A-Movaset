import 'package:flutter/material.dart';
import 'input_field_widget.dart';
import 'login_button_widget.dart';

class FormCardWidget extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool obscure;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;

  const FormCardWidget({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.obscure,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.12),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputFieldWidget(
            controller: emailCtrl,
            label: 'Username',
            hint: '',
            keyboardType: TextInputType.text,
            suffixColor: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 40),
          InputFieldWidget(
            controller: passwordCtrl,
            label: 'Password',
            hint: '',
            obscure: obscure,
            suffixIcon: obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            suffixColor: const Color(0xFF9AA0B2),
            onSuffixTap: onToggleObscure,
          ),
          const SizedBox(height: 80),
          LoginButtonWidget(isLoading: isLoading, onLogin: onLogin),
        ],
      ),
    );
  }
}