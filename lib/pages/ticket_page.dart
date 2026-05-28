import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/particle_background.dart';
import '../config/theme_config.dart';
import '../l10n/app_strings.dart';
import '../utils/privacy_utils.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  bool _isNameMasked = true;

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final lang = localeProvider.locale.languageCode;
    final List<dynamic> tickets = reservationProvider.tickets;
    
    final String englishFont = 'Orbitron';
    final String defaultFont = 'Orbitron';

    bool hasValidTicket = tickets.any((t) {
      String status = t['status'] ?? 'Valid';
      return status.contains('有效') || status == 'Valid';
    });

    return Scaffold(
      backgroundColor: const Color(0xFF050A0E),
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: InkWell(
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, color: ThemeConfig.neonCyan, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          lang == 'zh' ? '返回首页' : 'Home',
                          style: TextStyle(
                            color: ThemeConfig.neonCyan, 
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: lang == 'en' ? englishFont : 'Futuristic',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MY TICKETS',
                                  style: TextStyle(
                                    color: ThemeConfig.neonCyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontFamily: englishFont,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '我的预约票',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  'My Reservation Tickets',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontFamily: englishFont,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                _isNameMasked ? Icons.visibility_off : Icons.visibility,
                                color: ThemeConfig.neonCyan,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isNameMasked = !_isNameMasked;
                                });
                              },
                              tooltip: 'Toggle Name Privacy',
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Ticket Count
                        Text(
                          lang == 'zh' ? '共 ${tickets.length} 张票 · ${tickets.length} ticket(s)' : '${tickets.length} ticket(s) total',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: defaultFont,
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Ticket Cards
                        ...tickets.map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildTicketCard(context, t as Map<String, dynamic>, lang, englishFont),
                        )).toList(),
                        
                        const SizedBox(height: 20),

                        // Global Cancel Button
                        if (hasValidTicket)
                          Center(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.cancel_outlined, color: Colors.grey),
                              label: Text(
                                lang == 'en' ? 'Cancel Reservation' : '取消整个预约',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: const Color(0xFF111827),
                                    title: Text(lang == 'en' ? 'Cancel Reservation?' : '确认取消预约？', style: const TextStyle(color: Colors.white)),
                                    content: Text(lang == 'en' ? 'This action will cancel all tickets under this reservation and cannot be undone.' : '此操作将取消该预约下的所有门票，且不可撤销。', style: const TextStyle(color: Colors.white70)),
                                    actions: [
                                      TextButton(
                                        child: Text(lang == 'en' ? 'No' : '否', style: const TextStyle(color: Colors.white54)),
                                        onPressed: () => Navigator.pop(ctx, false),
                                      ),
                                      TextButton(
                                        child: Text(lang == 'en' ? 'Yes, Cancel' : '是，取消', style: const TextStyle(color: Colors.red)),
                                        onPressed: () => Navigator.pop(ctx, true),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  try {
                                    await Provider.of<ReservationProvider>(context, listen: false).cancelReservation();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                  }
                                }
                              },
                            ),
                          ),

                        const SizedBox(height: 40),
                        
                        // Footer Instruction
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '入馆时请向工作人员出示验证码',
                                  style: TextStyle(
                                    color: Colors.white70, 
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Please present verification code at entrance',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4), 
                                    fontSize: 12, 
                                    fontFamily: englishFont,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Map<String, dynamic> ticket, String lang, String englishFont) {
    String status = ticket['status'] ?? 'Valid';
    if (status.contains('有效') || status == 'Valid') status = 'Valid';
    else if (status.contains('已取消') || status == 'Cancelled') status = 'Cancelled';
    else if (status.contains('已使用') || status == 'Used') status = 'Used';
    else if (status.contains('已过期') || status == 'Expired') status = 'Expired';

    Color statusColor;
    switch (status) {
      case 'Cancelled':
        statusColor = Colors.grey;
        break;
      case 'Used':
        statusColor = Colors.red;
        break;
      case 'Expired':
        statusColor = Colors.yellow;
        break;
      default:
        statusColor = Colors.green;
        break;
    }

    String cnName = ticket['name_cn'] ?? '访客';
    String enName = ticket['name_en'] ?? 'Visitor';
    
    if (_isNameMasked) {
      cnName = PrivacyUtils.maskChineseName(cnName);
      enName = PrivacyUtils.maskEnglishName(enName);
    }

    String token = ticket['verification_code'] ?? 'FH-00000';
    token = PrivacyUtils.maskTicketNumber(token, status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeConfig.neonCyan.withOpacity(0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConfig.neonCyan.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cnName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            enName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                              fontFamily: englishFont,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.8), width: 1),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontFamily: englishFont,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ticket['type'] ?? '学生',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: lang == 'en' ? englishFont : 'Futuristic',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    '年级: ${ticket['grade'] ?? 'G8'}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: lang == 'en' ? englishFont : 'Futuristic',
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  Center(
                    child: Text(
                      token,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 42,
                        letterSpacing: 4,
                        fontFamily: englishFont,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(color: statusColor.withOpacity(0.5), blurRadius: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
