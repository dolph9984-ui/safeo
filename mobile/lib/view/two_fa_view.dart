import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/viewmodel/two_fa_viewmodel.dart';

class TwoFAView extends StatefulWidget {
  const TwoFAView({super.key});

  @override
  State<TwoFAView> createState() => _TwoFAViewState();
}

class _TwoFAViewState extends State<TwoFAView> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1565C0);
    const Color borderGray = Color(0xFFCFD8DC);
    const Color background = Color(0xFFF8FAFC);

    OutlineInputBorder baseBorder(Color color, {double width = 2}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ChangeNotifierProvider(
      create: (_) {
        final vm = TwoFAViewModel();
        vm.startTimer();
        return vm;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: primaryBlue),
            onPressed: () => Navigator.pop(context), // Retour à l'écran de Login
          ),
        ),

        body: SafeArea(
          child: Center( 
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Consumer<TwoFAViewModel>(
                builder: (context, vm, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_rounded, size: 100, color: primaryBlue),
                      const SizedBox(height: 16),
                      Text('SafeO', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: primaryBlue)),
                      const SizedBox(height: 8),
                      Text('Vérification en deux étapes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                      const SizedBox(height: 12),
                      Text('Saisissez le code à 6 chiffres envoyé par email', style: TextStyle(fontSize: 16, color: Colors.grey[700]), textAlign: TextAlign.center),
                      const SizedBox(height: 48),

                      // Les 6 cases PIN
                      AutofillGroup(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 45,
                              height: 55,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                enableSuggestions: false,
                                autocorrect: false,
                                textInputAction: index == 5 ? TextInputAction.done : TextInputAction.next,
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: baseBorder(borderGray),
                                  focusedBorder: baseBorder(primaryBlue, width: 3),
                                  errorBorder: baseBorder(Colors.red),
                                ),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                onChanged: (value) {
                                  if (value.length == 1 && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                  
                                  String fullCode = _controllers.map((c) => c.text).join();
                                  vm.updateCode(fullCode);
                                  
                                  if (fullCode.length == 6) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Zone d'erreur
                      if (vm.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.red.shade50, border: Border.all(color: Colors.red.shade200), borderRadius: BorderRadius.circular(12)),
                          child: Text(vm.errorMessage!, style: TextStyle(color: Colors.red.shade700), textAlign: TextAlign.center),
                        ),
                      const SizedBox(height: 24),

                      // Bouton Valider
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: vm.canSubmit
                              ? () async {
                                  FocusScope.of(context).unfocus();
                                  final success = await vm.submit();
                                  if (success && context.mounted) {
                                    // Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion réussie !')));
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4),
                          child: vm.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Vérifier le code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Lien Renvoyer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            vm.canResend ? "Vous n'avez pas reçu le code ?" : "Renvoyer le code dans", 
                            style: TextStyle(color: Colors.grey[700])
                          ),
                          TextButton(
                            onPressed: vm.canResend && !vm.isLoading ? vm.resend : null,
                            child: Text(
                              vm.canResend ? 'Renvoyer' : '${vm.timerSeconds}s',
                              style: TextStyle(
                                color: vm.canResend ? primaryBlue : Colors.grey,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
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