import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/auth/components/auth_components.dart';
import 'package:securite_mobile/view/auth/components/auth_scrollable_body.dart';
import 'package:securite_mobile/view/auth/components/labeled_text_field_components.dart';
import 'package:securite_mobile/view/auth/components/loading_elevated_button_components.dart';
import 'package:securite_mobile/viewmodel/auth/login_viewmodel.dart';
import 'package:securite_mobile/viewmodel/auth/oauth_viewmodel.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => OAuthViewModel()),
      ],
      child: Consumer2<LoginViewModel, OAuthViewModel>(
        builder: (context, loginVm, oauthVm, _) {
          return AuthLayout(
            onBackPressed: () => context.canPop()
                ? context.pop()
                : context.go(AppRoutes.onboarding),
            child: AuthScrollableBody(
              children: [
                Center(
                  child: Text('Se connecter', style: textTheme.headlineLarge),
                ),
                const SizedBox(height: 40),

                LabeledTextField(
                  label: 'Adresse email',
                  hintText: 'ex: rabe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: loginVm.updateEmail,
                ),

                const SizedBox(height: 24),

                LabeledTextField(
                  label: 'Mot de passe',
                  hintText: '••••••••••',
                  obscureText: _obscurePassword,
                  onChanged: loginVm.updatePassword,
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

                AuthErrorMessage(
                  message: loginVm.errorMessage ?? oauthVm.errorMessage,
                ),
                const SizedBox(height: 35),

                LoadingElevatedButton(
                  label: 'Se connecter',
                  isLoading: loginVm.isLoading,
                  onPressed: loginVm.canSubmit
                      ? () async {
                          final response = await loginVm.submit();
                          if (response != null && context.mounted) {
                            context.go(
                              AppRoutes.twoFA,
                              extra: {
                                'verificationToken': response.verificationToken,
                                'mode': TwoFAMode.login,
                                'email': loginVm.email,
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
                      context: 'login_screen',
                    );

                    if (success && context.mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
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
