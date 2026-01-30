import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/services/auth/auth_storage_service.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';
import 'package:provider/provider.dart';

class TwoFAView extends StatefulWidget {
  final String verificationToken;
  final TwoFAMode mode;

  const TwoFAView({
    super.key,
    required this.verificationToken,
    this.mode = TwoFAMode.login,
  });

  @override
  State<TwoFAView> createState() => _TwoFAViewState();
}

class _TwoFAViewState extends State<TwoFAView> {
  final AuthStorageService _authStorage = AuthStorageService();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() { if (mounted) setState(() {}); });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index, TwoFAViewModel vm) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    vm.updateCode(_controllers.map((c) => c.text).join());
  }

  void _handlePaste(String pastedText, int startIndex, TwoFAViewModel vm) {
    final cleanedText = pastedText.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < cleanedText.length && (startIndex + i) < 6; i++) {
      _controllers[startIndex + i].text = cleanedText[i];
    }
    final lastIdx = (startIndex + cleanedText.length - 1).clamp(0, 5);
    if (lastIdx < 5 && cleanedText.length < 6) {
      _focusNodes[lastIdx + 1].requestFocus();
    } else {
      _focusNodes[lastIdx].unfocus();
    }
    vm.updateCode(_controllers.map((c) => c.text).join());
  }

  TextInputFormatter _buildPasteFormatter(int index, TwoFAViewModel vm) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.length > 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _handlePaste(newValue.text, index, vm));
        return TextEditingValue(
          text: newValue.text.isNotEmpty ? newValue.text[0] : '',
          selection: TextSelection.collapsed(offset: newValue.text.isNotEmpty ? 1 : 0),
        );
      }
      return newValue;
    });
  }

  void _onKeyEvent(KeyEvent event, int index, TwoFAViewModel vm) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      } else {
        _controllers[index].clear();
      }
      vm.updateCode(_controllers.map((c) => c.text).join());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => context.canPop() ? context.pop() : context.go(Routes.login),
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/logo_safeo.svg',
              height: 40,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Consumer<TwoFAViewModel>(
                  builder: (context, vm, child) {
                    final bool hasError = vm.errorMessage != null;

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  'Entrer le code de\nvérification',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 16),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: theme.textTheme.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Nous avons envoyé un code à 6 chiffres à l\'email:'),
                                      TextSpan(
                                        text: ' "${vm.email ?? 'votre email'}"', 
                                        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                const Align(
                                  alignment: Alignment.centerLeft, 
                                  child: Text('Code', style: TextStyle(fontWeight: FontWeight.w600))
                                ),
                                const SizedBox(height: 12),
                                
                                // --- OTP ROW ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) {
                                    final bool isFocused = _focusNodes[index].hasFocus;
                                    final bool isFilled = _controllers[index].text.isNotEmpty;
                                    
                                    return Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        height: 62,
                                        constraints: const BoxConstraints(maxWidth: 48), 
                                        child: KeyboardListener(
                                          focusNode: FocusNode(canRequestFocus: false), 
                                          onKeyEvent: (event) => _onKeyEvent(event, index, vm),
                                          child: TextField(
                                            controller: _controllers[index],
                                            focusNode: _focusNodes[index],
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            maxLength: 1,
                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0A0E27)),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              filled: true,
                                              // Utilise errorContainer si erreur, sinon blanc/gris
                                              fillColor: hasError 
                                                  ? theme.colorScheme.errorContainer.withOpacity(0.2) 
                                                  : (isFilled || isFocused ? Colors.white : const Color(0xFFF5F5F5)),
                                              contentPadding: EdgeInsets.zero,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: hasError ? theme.colorScheme.error : (isFilled ? theme.primaryColor : Colors.transparent), 
                                                  width: 1.5
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: hasError ? theme.colorScheme.error : theme.primaryColor, 
                                                  width: 2
                                                ),
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly, 
                                              _buildPasteFormatter(index, vm)
                                            ],
                                            onChanged: (value) => _onChanged(value, index, vm),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                // AFFICHAGE DU MESSAGE D'ERREUR
                                if (hasError) ...[
                                  const SizedBox(height: 20),
                                  Container(
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
                                ],

                                const SizedBox(height: 32),
                                
                                ElevatedButton(
                                  onPressed: vm.canSubmit ? () async {
                                    FocusScope.of(context).unfocus();
                                    final response = await vm.verifyCode();
                                    if (response != null && context.mounted) {
                                      await _authStorage.saveAccessToken(response.accessToken);
                                      context.go(Routes.home);
                                    }
                                  } : null,
                                  child: vm.isLoading 
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('Confirmer'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Code non recu? ', style: theme.textTheme.bodyMedium),
                              GestureDetector(
                                onTap: vm.isResending ? null : () async {
                                  final success = await vm.resendCode();
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code renvoyé'), backgroundColor: AppColors.success));
                                  }
                                },
                                child: vm.isResending 
                                  ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                                  : Text('Renvoyer', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }
}