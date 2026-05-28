import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/particle_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/language_toggle.dart';
import '../widgets/scanline_overlay.dart';
import '../widgets/animated_rings.dart';
import '../widgets/announcement_modal.dart';
import '../config/theme_config.dart';
import '../l10n/app_strings.dart';
import 'reservation_flow_page.dart';
import 'ticket_page.dart';
import 'admin/admin_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _adminTapCount = 0;

  @override
  void initState() {
    super.initState();
    // Refresh reservation status when home page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationProvider>().initialize();
    });
  }

  void _handleAdminTap() {
    setState(() {
      _adminTapCount++;
      if (_adminTapCount >= 8) {
        _adminTapCount = 0;
        _showAdminLogin();
      }
    });
  }

  void _showAdminLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final lang = localeProvider.locale.languageCode;
    const String englishFont = 'Orbitron';
    const String defaultFont = 'Orbitron';

    return Scaffold(
      backgroundColor: const Color(0xFF050A0E),
      body: Stack(
        children: [
          const ParticleBackground(),
          const ScanlineOverlay(),
          // Top Left Radial Glow
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: [
                    ThemeConfig.neonCyan.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          // Bottom Right Radial Glow
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.30,
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.0,
                  colors: [
                    ThemeConfig.electricBlue.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          // Vignette
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Bar / Hidden Admin Entrance
                GestureDetector(
                  onTap: _handleAdminTap,
                  child: Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      border: Border(
                        bottom: BorderSide(
                          color: ThemeConfig.neonCyan.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.get('app_title', lang),
                      style: TextStyle(
                        fontFamily: defaultFont,
                        fontSize: 14,
                        letterSpacing: 4,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AnimatedRingsLogo(text: 'FH'),
                          const SizedBox(height: 40),
                          
                          Text(
                            AppStrings.get('app_title', lang),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  letterSpacing: -0.5,
                                  fontFamily: defaultFont,
                                  fontSize: 64, // clamp visually
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.08),
                                      blurRadius: 40,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.get('subtitle', lang),
                            style: TextStyle(
                              fontFamily: defaultFont,
                              fontSize: 14,
                              letterSpacing: 4.5,
                              color: ThemeConfig.neonCyan,
                              shadows: [
                                Shadow(
                                  color: ThemeConfig.neonCyan.withOpacity(0.4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 128,
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  ThemeConfig.neonCyan.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '电子研究俱乐部 · 义卖会活动',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              letterSpacing: 2.0,
                              color: Colors.white.withOpacity(0.38),
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Countdown
                          CountdownTimer(
                            targetDate: () {
                              final ct = reservationProvider.closeTime;
                              if (ct != null && ct.isNotEmpty) {
                                try {
                                  return DateTime.parse(ct.replaceAll(' ', 'T'));
                                } catch (_) {}
                              }
                              return DateTime(2026, 6, 1); // fallback
                            }(),
                          ),
                          
                          const SizedBox(height: 80),
                          
                          // CTA Button
                          if (!reservationProvider.isInitialCheckDone)
                            const CircularProgressIndicator(color: ThemeConfig.neonCyan)
                          else if (reservationProvider.isReserved)
                            NeonButton(
                              text: AppStrings.get('view_ticket', lang),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TicketPage()),
                                );
                              },
                              icon: Icons.qr_code_rounded,
                            )
                          else if (!reservationProvider.isSystemOpen)
                            Opacity(
                              opacity: 0.5,
                              child: NeonButton(
                                text: 'RESERVATION CLOSED',
                                onPressed: () {}, // Disabled-like behavior
                                icon: Icons.lock_clock_rounded,
                              ),
                            )
                          else
                            NeonButton(
                              text: AppStrings.get('reserve_now', lang),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ReservationFlowPage()),
                                );
                              },
                              icon: Icons.arrow_forward_rounded,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  ThemeConfig.neonCyan.withOpacity(0.2),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'V5.0',
                            style: TextStyle(
                              fontFamily: englishFont,
                              fontSize: 9,
                              letterSpacing: 3.0,
                              color: ThemeConfig.neonCyan.withOpacity(0.25),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 48,
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ThemeConfig.neonCyan.withOpacity(0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '© ForHim ERC · V5.0 Stable Release · V5.0 稳定正式版',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.15),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating Language Button
          Positioned(
            bottom: 24,
            right: 24,
            child: const LanguageToggle(),
          ),
          // Floating Announcement Button
          Positioned(
            top: 60,
            right: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.campaign_outlined, color: ThemeConfig.neonCyan),
                onPressed: () => showAnnouncementModal(context),
                style: IconButton.styleFrom(
                  backgroundColor: ThemeConfig.neonCyan.withOpacity(0.1),
                  side: BorderSide(color: ThemeConfig.neonCyan.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
