import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/view/auth/components/auth_components.dart';
import 'package:securite_mobile/view/auth/components/auth_scrollable_body.dart';
import 'package:securite_mobile/view/auth/components/labeled_text_field_components.dart';
import 'package:securite_mobile/view/auth/components/loading_elevated_button_components.dart';
import 'package:securite_mobile/viewmodel/auth/login_viewmodel.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return AuthLayout(
            onBackPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.onboarding),
            child: AuthScrollableBody(
              children: [
                Center(child: Text('Se connecter', style: textTheme.headlineLarge)),
                const SizedBox(height: 40),

                LabeledTextField(
                  label: 'Adresse email',
                  hintText: 'ex: rabe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: vm.updateEmail,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Mot de passe',
                  hintText: '••••••••••',
                  obscureText: _obscurePassword,
                  onChanged: vm.updatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                AuthErrorMessage(message: vm.errorMessage),
                const SizedBox(height: 35),

                LoadingElevatedButton(
                  label: 'Se connecter',
                  isLoading: vm.isLoading,
                  onPressed: vm.canSubmit
                      ? () async {
                          final response = await vm.submit();
                          if (response != null && context.mounted) {
                            context.go(
                              AppRoutes.twoFA,
                              extra: {
                                'verificationToken': response.verificationToken,
                                'mode': TwoFAMode.login,
                                'email': vm.email,
                              },
                            );
                          }
                        }
                      : null,
                ),

                const SizedBox(height: 25),
                const AuthDivider(),
                const SizedBox(height: 25),

                GoogleAuthButton(
                  onPressed: () => debugPrint('Google Login'),
                ),

                const Spacer(),
                AuthFooter(
                  text: 'Pas encore de compte?',
                  linkText: "S'inscrire",
                  onTap: () => context.go(AppRoutes.signup),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
