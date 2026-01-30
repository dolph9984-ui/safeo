import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/view/auth/two_fa_view.dart';
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
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Scaffold(
        // backgroundColor piloté par le thème (AppColors.primary)
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left,color: Colors.white, size: 32),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.login);
                      }
                    },
                  ),
                ),
              ),

              // LOGO
              SvgPicture.asset(
                'assets/icons/logo_safeo.svg',
                height: 40,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),

              const SizedBox(height: 40),

              // CARTE BLANCHE
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 64,
                          ),
                          child: IntrinsicHeight(
                            child: Consumer<SignupViewModel>(
                              builder: (context, vm, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Créer un compte',
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),

                                    // CHAMP NOM COMPLET
                                    const Text('Nom complet', style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    TextField(
                                      textInputAction: TextInputAction.next,
                                      onChanged: vm.updateFullName,
                                      decoration: InputDecoration(
                                        hintText: 'ex: Rabe Andry',
                                        errorText: vm.fullNameError,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // CHAMP EMAIL
                                    const Text('Adresse email', style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onChanged: vm.updateEmail,
                                      decoration: InputDecoration(
                                        hintText: 'ex: rabe@example.com',
                                        errorText: vm.emailError,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // CHAMP MOT DE PASSE
                                    const Text('Créer votre mot de passe', style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    TextField(
                                      obscureText: _obscurePassword,
                                      textInputAction: TextInputAction.next,
                                      onChanged: vm.updatePassword,
                                      decoration: InputDecoration(
                                        hintText: '••••••••••',
                                        errorText: vm.passwordError,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          ),
                                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // CHAMP CONFIRMATION
                                    const Text('Confirmer le mot de passe', style: TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    TextField(
                                      obscureText: _obscureConfirmPassword,
                                      textInputAction: TextInputAction.done,
                                      onChanged: vm.updateConfirmPassword,
                                      decoration: InputDecoration(
                                        hintText: '••••••••••',
                                        errorText: vm.confirmPasswordError,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          ),
                                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // --- AJOUT : MESSAGE D'ERREUR GLOBAL DU SERVEUR ---
                                    if (vm.errorMessage != null)
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppColors.error.withOpacity(0.2)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                vm.errorMessage!,
                                                style: const TextStyle(
                                                  color: AppColors.error,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // BOUTON S'INSCRIRE
                                    ElevatedButton(
                                      onPressed: vm.canSubmit ? () async {
                                        FocusScope.of(context).unfocus();
                                        final response = await vm.submit();
                                        if (response != null && context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeNotifierProvider(
                                                create: (_) {
                                                  // Correction du nom de variable (pas de chiffre au début)
                                                  final signupTwoFAVm = TwoFAViewModel(
                                                    verificationToken: response.verificationToken,
                                                    mode: TwoFAMode.signup,
                                                  );
                                                  signupTwoFAVm.setEmail(vm.email);
                                                  return signupTwoFAVm;
                                                },
                                                child: TwoFAView(
                                                  verificationToken: response.verificationToken,
                                                  mode: TwoFAMode.signup,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } : null,
                                      child: vm.isLoading
                                          ? const SizedBox(
                                              height: 20, 
                                              width: 20, 
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                            )
                                          : const Text('S\'inscrire'),
                                    ),

                                    const SizedBox(height: 25),

                                    // DIVIDER
                                    const Row(
                                      children: [
                                        Expanded(child: Divider(color: AppColors.borderGray, thickness: 1)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: Text('ou', style: TextStyle(color: AppColors.textHint, fontSize: 15)),
                                        ),
                                        Expanded(child: Divider(color: AppColors.borderGray, thickness: 1)),
                                      ],
                                    ),

                                    const SizedBox(height: 25),

                                    // BOUTON GOOGLE
                                    OutlinedButton(
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset('assets/icons/google_icon.svg', width: 22),
                                          const SizedBox(width: 12),
                                          const Text('Continuer avec Google'),
                                        ],
                                      ),
                                    ),

                                    const Spacer(),

                                    // FOOTER
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Déjà un compte? ',
                                            style: TextStyle(color: AppColors.textHint, fontSize: 15),
                                          ),
                                          GestureDetector(
                                            onTap: () => context.go(Routes.login),
                                            child: Text(
                                              'Se connecter',
                                              style: TextStyle(
                                                color: theme.primaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}