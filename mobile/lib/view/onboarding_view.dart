import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B93FF), Color(0xFF536DFE)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. LOGO
                          SvgPicture.asset(
                            'assets/icons/logo_safeo.svg',
                            height: 35,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),

                          const SizedBox(height: 20),

                          // 2. ILLUSTRATION (Flexible mais contenue)
                          Expanded(
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/onboarding_illustration.svg',
                                width: constraints.maxWidth * 0.85,
                                fit: BoxFit.contain, // Important pour ne pas déborder
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 3. TEXTE
                          const Text(
                            'Vos documents\nsensibles, en\nsécurité',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: -1.2,
                            ),
                          ),

                          const SizedBox(height: 30),
ElevatedButton(
  onPressed: () async {
    try {
      final response = await Dio().get('https://safeo.greny.app/ping'); // ou un endpoint qui existe
      print('Réponse : ${response.data}');
    } catch (e) {
      print('Erreur réseau : $e');
    }
  },
  child: Text('Test Connexion API'),
),
                          // 4. BOUTON AVEC NAVIGATION
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () => context.go(Routes.login),
                                child: Container(
                                  width: 80,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.north_east,
                                    color: Color(0xFF536DFE),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}