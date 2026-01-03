import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/routes.dart';
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
    const Color primaryBlue = Color(0xFF1565C0);
    const Color borderGray = Color(0xFFCFD8DC);
    const Color background = Color(0xFFF8FAFC);

    OutlineInputBorder baseBorder(Color color, {double width = 2}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView( 
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Consumer<LoginViewModel>(
                builder: (context, vm, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        size: 100,
                        color: primaryBlue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'SafeO',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Votre coffre-fort numérique sécurisé',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center, 
                      ),
                      const SizedBox(height: 60),
            
                      // Email
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined, color: primaryBlue),
                          enabledBorder: baseBorder(borderGray),
                          focusedBorder: baseBorder(primaryBlue, width: 3),
                          errorBorder: baseBorder(Colors.red),
                          focusedErrorBorder: baseBorder(Colors.red, width: 3),
                          errorText: vm.emailError,
                        ),
                        onChanged: vm.updateEmail,
                      ),
                      const SizedBox(height: 20),
            
                      // Mot de passe
                      TextField(
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock_outline, color: primaryBlue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: primaryBlue,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          enabledBorder: baseBorder(borderGray),
                          focusedBorder: baseBorder(primaryBlue, width: 3),
                          errorBorder: baseBorder(Colors.red),
                          focusedErrorBorder: baseBorder(Colors.red, width: 3),
                          errorText: vm.passwordError,
                        ),
                        onChanged: vm.updatePassword,
                      ),
                      const SizedBox(height: 24),
            
                      // Erreur serveur
                      if (vm.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            vm.errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 24),
            
                      // Bouton
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: vm.canSubmit
                              ? () async {
                                  FocusScope.of(context).unfocus(); 
                                  
                                  final success = await vm.submit();
                                  if (success && context.mounted) {
                                    Navigator.pushNamed(context, Routes.twoFA);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          child: vm.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Se connecter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
            
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: () {},
                        child: Text('Mot de passe oublié ?', style: TextStyle(color: primaryBlue)),
                      ),
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