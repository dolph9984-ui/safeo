import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/view/auth/components/auth_components.dart';
import 'package:securite_mobile/view/auth/components/auth_scrollable_body.dart';
import 'package:securite_mobile/view/auth/components/labeled_text_field_components.dart';
import 'package:securite_mobile/view/auth/components/loading_elevated_button_components.dart';
import 'package:securite_mobile/viewmodel/auth/signup_viewmodel.dart';
import 'package:securite_mobile/viewmodel/auth/oauth_viewmodel.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => OAuthViewModel()),
      ],
      child: Consumer2<SignupViewModel, OAuthViewModel>(
        builder: (context, signupVm, oauthVm, _) {
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
                  onChanged: signupVm.updateFullName,
                  errorText: signupVm.fullNameError,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Adresse email',
                  hintText: 'ex: rabe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: signupVm.updateEmail,
                  errorText: signupVm.emailError,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Créer votre mot de passe',
                  hintText: '••••••••••',
                  obscureText: _obscurePassword,
                  onChanged: signupVm.updatePassword,
                  errorText: signupVm.passwordError,
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
                  onChanged: signupVm.updateConfirmPassword,
                  errorText: signupVm.confirmPasswordError,
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

                AuthErrorMessage(message: signupVm.errorMessage ?? oauthVm.errorMessage),
                const SizedBox(height: 24),

                LoadingElevatedButton(
                  label: "S'inscrire",
                  isLoading: signupVm.isLoading,
                  onPressed: signupVm.canSubmit
                      ? () async {
                          final response = await signupVm.submit();
                          if (response != null && context.mounted) {
                            context.go(
                              AppRoutes.twoFA,
                              extra: {
                                'verificationToken':
                                    response.verificationToken,
                                'mode': TwoFAMode.signup,
                                'email': signupVm.email,
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
                  isLoading: oauthVm.isLoading,
                  onPressed: () async {
                    final success = await oauthVm.googleLogin(
                      context: 'signup_screen',
                    );
                    
                    if (success && context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
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