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
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. LOGO (Padding séparé pour ne pas gêner l'image)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SvgPicture.asset(
                            'assets/icons/logo_safeo.svg',
                            height: 35,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),

                        // 2. ILLUSTRATION (Maximisée)
                        // On lui donne 55% de la hauteur totale pour qu'elle soit imposante
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/onboarding_illustration.svg',
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.55, 
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // 3. ZONE BASSE (Texte + Bouton)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => context.go(AppRoutes.login),
                                    borderRadius: BorderRadius.circular(20),
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
                      ],
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