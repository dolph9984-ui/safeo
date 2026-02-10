import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/permissions.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/services/biometric_service.dart';

class BatteryMonitorView extends StatefulWidget {
  const BatteryMonitorView({super.key});

  @override
  State<BatteryMonitorView> createState() => _BatteryMonitorViewState();
}

class _BatteryMonitorViewState extends State<BatteryMonitorView>
    with WidgetsBindingObserver {
  final Battery _battery = Battery();
  final BiometricAuthService _biometricAuth = BiometricAuthService();
  int _level = 0;
  BatteryState _state = BatteryState.unknown;
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _battery.batteryLevel.then((lvl) {
      if (mounted) setState(() => _level = lvl);
    });
    _battery.onBatteryStateChanged.listen((s) {
      if (mounted) setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed && _pausedTime != null) {
      if (DateTime.now().difference(_pausedTime!).inSeconds >= 5) {
        isAppUnlocked.value = false;
      }
      _pausedTime = null;
    }
  }

  Future<void> _authenticate() async {
    if (await _biometricAuth.authenticate()) {
      isAppUnlocked.value = true;
      final logged = await SessionModel().isLoggedIn;
      if (mounted) {
        context.go(logged ? AppRoutes.userFiles : AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCharging = _state == BatteryState.charging;

    return Scaffold(
      appBar: AppBar(
        title: Text('Batterie', style: theme.textTheme.headlineLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            GestureDetector(
              onTap: _authenticate,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCharging
                            ? Icons.bolt_rounded
                            : Icons.battery_full_rounded,
                        size: 40,
                        color: isCharging
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                      Text(
                        '$_level%',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        isCharging ? 'Charge en cours' : 'Optimisé',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile(context, Icons.health_and_safety, "Santé", "100%"),
                  _infoTile(context, Icons.thermostat, "Temp.", "24°C"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
