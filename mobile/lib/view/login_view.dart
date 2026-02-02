// lib/view/login_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Consumer<LoginViewModel>(
                builder: (context, vm, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_rounded, size: 100),
                      const SizedBox(height: 16),

                      Text(
                        'SafeO',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Votre coffre-fort numérique sécurisé',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),

                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ).copyWith(errorText: vm.emailError),
                        onChanged: vm.updateEmail,
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ).copyWith(errorText: vm.passwordError),
                        onChanged: vm.updatePassword,
                      ),
                      const SizedBox(height: 24),

                      if (vm.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            vm.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: vm.canSubmit
                            ? () async {
                                FocusScope.of(context).unfocus();
                                final success = await vm.submit();
                                if (success && context.mounted) {
                                  Navigator.pushNamed(context, Routes.twoFA);
                                }
                              }
                            : null,
                        child: vm.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Se connecter'),
                      ),

                      const SizedBox(height: 32),

                      TextButton(
                        onPressed: () {},
                        child: const Text('Mot de passe oublié ?'),
                      ),

                      // ========================
                      // OAuth buttons (en bas)
                      // ========================
                      const SizedBox(height: 40),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[400])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OU',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[400])),
                        ],
                      ),
                      const SizedBox(height: 24),

                      OutlinedButton.icon(
                        icon: const Icon(Icons.android, size: 24),
                        label: const Text('Continuer avec Google'),
                        onPressed: () async {
                          final isLoginSuccess = await vm.oAuthLogin();

                          if (isLoginSuccess && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Connexion Google réussie ! (simulation)',
                                ),
                              ),
                            );
                            Navigator.pushNamed(context, Routes.home);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        icon: const Icon(Icons.apple, size: 28),
                        label: const Text('Continuer avec Apple'),
                        onPressed: () async {
                          vm.setLoading(true);

                          await Future.delayed(const Duration(seconds: 2));

                          vm.setLoading(false);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Connexion Apple réussie ! (simulation)',
                                ),
                              ),
                            );
                            Navigator.pushNamed(context, Routes.twoFA);
                          }
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
