import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';
import 'package:securite_mobile/view/auth/components/auth_components.dart';
import 'package:securite_mobile/view/auth/components/auth_scrollable_body.dart';
import 'package:securite_mobile/view/auth/components/loading_elevated_button_components.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';

class TwoFAView extends StatefulWidget {
  final String verificationToken;
  final TwoFAMode mode;
  final String? email;

  const TwoFAView({
    super.key,
    required this.verificationToken,
    this.mode = TwoFAMode.login,
    this.email,
  });

  @override
  State<TwoFAView> createState() => _TwoFAViewState();
}

class _TwoFAViewState extends State<TwoFAView> {
  final _storage = SecureStorageService();
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (final node in _focusNodes) {
      node.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }


  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final n in _focusNodes) n.dispose();
    super.dispose();
  }

  void _updateCode(TwoFAViewModel vm) {
    vm.updateCode(_controllers.map((c) => c.text).join());
  }

  void _onChanged(String value, int index, TwoFAViewModel vm) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    _updateCode(vm);
  }

  void _onKey(KeyEvent event, int index, TwoFAViewModel vm) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
      } else {
        _controllers[index].clear();
      }
      _updateCode(vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => TwoFAViewModel(
        verificationToken: widget.verificationToken,
        mode: widget.mode,
      ),
      child: Consumer<TwoFAViewModel>(
        builder: (context, vm, _) {
          return AuthLayout(
            onBackPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.login),
            child: AuthScrollableBody(
              children: [
                Center(
                  child: Text(
                    'Entrer le code de\nvérification',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        const TextSpan(
                          text:
                              'Nous avons envoyé un code à 6 chiffres à\nl\'email : ',
                        ),
                        TextSpan(
                          text: widget.email ?? vm.email ?? 'votre email',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                const Text('Code', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    final hasError = vm.errorMessage != null;
                    final isFilled = _controllers[index].text.isNotEmpty;
                    final hasFocus = _focusNodes[index].hasFocus;

                    return Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 62,
                        constraints: const BoxConstraints(maxWidth: 48),
                        child: KeyboardListener(
                          focusNode: FocusNode(canRequestFocus: false),
                          onKeyEvent: (e) => _onKey(e, index, vm),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0A0E27),
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: hasError
                                  ? theme.colorScheme.errorContainer
                                      .withValues(alpha: 0.2)

                                  : (isFilled || hasFocus
                                      ? Colors.white
                                      : const Color(0xFFF5F5F5)),
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: hasError
                                      ? theme.colorScheme.error
                                      : isFilled
                                          ? theme.primaryColor
                                          : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: hasError
                                      ? theme.colorScheme.error
                                      : theme.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (v) => _onChanged(v, index, vm),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                AuthErrorMessage(message: vm.errorMessage),
                const SizedBox(height: 32),

                LoadingElevatedButton(
                  label: 'Confirmer',
                  isLoading: vm.isLoading,
                  onPressed: vm.canSubmit
                      ? () async {
                          FocusScope.of(context).unfocus();
                          final success = await vm.verifyAndPersist();
                          if (success && context.mounted) {
                            context.go(AppRoutes.home);
                          }
                        }
                      : null,
                ),


                const Spacer(),

                _ResendCodeFooter(viewModel: vm),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResendCodeFooter extends StatelessWidget {
  final TwoFAViewModel viewModel;

  const _ResendCodeFooter({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Code non reçu?'),
          const SizedBox(width: 4),
          if (viewModel.isResending)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            )
          else if (!viewModel.canResend)
            Row(
              children: [
                Text(
                  ' Renvoyer',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${viewModel.resendCountdown}s)',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: () async {
                final ok = await viewModel.resendCode();
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Code renvoyé'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text(
                ' Renvoyer',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}