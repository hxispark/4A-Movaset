import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../pages/login_page.dart';

class AppHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final bool showAvatar;

  const AppHeader({
    super.key,
    this.greeting = 'Halo, ',
    this.name = 'User',
    this.showAvatar = true,
  });

  const AppHeader.centered({
    super.key,
    required String title,
  })  : greeting = title,
        name = '',
        showAvatar = false;

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDED),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Color(0xFFEF4444), size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar Akun?',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3142)),
            ),
            const SizedBox(height: 6),
            Text(
              'Kamu akan keluar dari sesi ini.\nYakin ingin melanjutkan?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF9AA0B2),
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9AA0B2)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('is_logged_in');
                      await prefs.remove('logged_in_user');
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) => const LoginPage(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Keluar',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: r.hPad,
        right: r.hPad,
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 18,
      ),
      child: showAvatar
          ? _buildGreeting(r, context)
          : Center(
              child: Text(
                greeting,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: r.scaledFont(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
    );
  }

  Widget _buildGreeting(Responsive r, BuildContext context) {
    return Row(
      children: [
        Container(
          width: r.isSmall ? 32 : 38,
          height: r.isSmall ? 32 : 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline,
              color: AppColors.white, size: r.scaledIcon(20)),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            text: greeting,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: r.scaledFont(20),
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: name,
                style: GoogleFonts.poppins(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _handleLogout(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFEF4444).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout_rounded,
                    color: Color(0xFFFF6B6B), size: 15),
                const SizedBox(width: 5),
                Text(
                  'Keluar',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFF6B6B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}