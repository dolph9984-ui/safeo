import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/viewmodel/auth/login_viewmodel.dart';
import 'package:securite_mobile/view/auth/two_fa_view.dart';
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
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // HEADER : Bouton retour
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(Routes.onboarding);
                      }
                    },
                  ),
                ),
              ),

              // LOGO SVG
              SvgPicture.asset(
                'assets/icons/logo_safeo.svg',
                height: 40,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
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
                            child: Consumer<LoginViewModel>(
                              builder: (context, vm, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),

                                    // CHAMP EMAIL
                                    const Text(
                                      'Adresse email',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1D2E)),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: vm.updateEmail,
                                      decoration: const InputDecoration(
                                        hintText: 'ex: rabe@example.com',
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // CHAMP MOT DE PASSE
                                    const Text(
                                      'Mot de passe',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1D2E)),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      obscureText: _obscurePassword,
                                      onChanged: vm.updatePassword,
                                      decoration: InputDecoration(
                                        hintText: '••••••••••',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            color: const Color(0xFF1A1D2E),
                                          ),
                                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                      ),
                                    ),

                                    // --- GESTION DES ERREURS (REAJOUTÉ) ---
                                    if (vm.errorMessage != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.errorLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                vm.errorMessage!,
                                                style: const TextStyle(color: AppColors.errorDark, fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 35),

                                    // BOUTON SE CONNECTER
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
                                                  final vModel = TwoFAViewModel(
                                                    verificationToken: response.verificationToken,
                                                    mode: TwoFAMode.login,
                                                  );
                                                  vModel.setEmail(vm.email);
                                                  return vModel;
                                                },
                                                child: TwoFAView(
                                                  verificationToken: response.verificationToken,
                                                  mode: TwoFAMode.login,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } : null,
                                      child: vm.isLoading 
                                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                          : const Text('Se connecter'),
                                    ),

                                    const SizedBox(height: 25),

                                    const Row(
                                      children: [
                                        Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          child: Text('ou', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15)),
                                        ),
                                        Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
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
                                          const Text(
                                            'Continuer avec Google',
                                            style: TextStyle(color: Color(0xFF1A1D2E), fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Spacer(), 

                                    // FOOTER (Pas encore de compte...)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Pas encore de compte? ',
                                            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
                                          ),
                                          GestureDetector(
                                            onTap: () => context.go(Routes.signup),
                                            child: const Text(
                                              "S'inscrire",
                                              style: TextStyle(
                                                color: AppColors.primary,
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