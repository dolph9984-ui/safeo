import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/view/auth/components/auth_components.dart';
import 'package:securite_mobile/view/auth/components/auth_scrollable_body.dart';
import 'package:securite_mobile/view/auth/components/labeled_text_field_components.dart';
import 'package:securite_mobile/view/auth/components/loading_elevated_button_components.dart';
import 'package:securite_mobile/viewmodel/auth/signup_viewmodel.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Consumer<SignupViewModel>(
        builder: (context, vm, _) {
          return AuthLayout(
            onBackPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.login),
            child: AuthScrollableBody(
              children: [
                Center(
                  child: Text(
                    'Créer un compte',
                    style: textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 40),

                LabeledTextField(
                  label: 'Nom complet',
                  hintText: 'ex: Rabe Andry',
                  onChanged: vm.updateFullName,
                  errorText: vm.fullNameError,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Adresse email',
                  hintText: 'ex: rabe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: vm.updateEmail,
                  errorText: vm.emailError,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Créer votre mot de passe',
                  hintText: '••••••••••',
                  obscureText: _obscurePassword,
                  onChanged: vm.updatePassword,
                  errorText: vm.passwordError,
                  textInputAction: TextInputAction.next,
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

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Confirmer le mot de passe',
                  hintText: '••••••••••',
                  obscureText: _obscureConfirmPassword,
                  onChanged: vm.updateConfirmPassword,
                  errorText: vm.confirmPasswordError,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),

                AuthErrorMessage(message: vm.errorMessage),
                const SizedBox(height: 24),

                LoadingElevatedButton(
                  label: "S'inscrire",
                  isLoading: vm.isLoading,
                  onPressed: vm.canSubmit
                      ? () async {
                          final response = await vm.submit();
                          if (response != null && context.mounted) {
                            context.go(
                              AppRoutes.twoFA,
                              extra: {
                                'verificationToken':
                                    response.verificationToken,
                                'mode': TwoFAMode.signup,
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
                  onPressed: () => debugPrint('Google Signup'),
                ),

                const Spacer(),

                AuthFooter(
                  text: 'Déjà un compte?',
                  linkText: 'Se connecter',
                  onTap: () => context.go(AppRoutes.login),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
