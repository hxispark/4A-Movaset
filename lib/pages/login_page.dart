import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Handle login & tampilkan success popup ──────────────────────────────
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username dan password harus diisi',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi delay login (ganti dengan Firebase Auth nanti)
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (!mounted) return;

    // Tampilkan popup sukses
    await _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, _, __) => const _SuccessDialog(),
    );

    if (!mounted) return;

    // Setelah dialog ditutup → navigasi ke MainPage
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => const MainPage(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 35, 118),
                  Color.fromARGB(255, 8, 31, 78),
                  Color.fromARGB(255, 11, 54, 97),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Blob dekorasi ──
          Positioned(
            top: -80, left: -60,
            child: _GradientBlob(
              width: 280, height: 280,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          Positioned(
            top: 40, right: -30,
            child: _GradientBlob(
              width: 130, height: 130,
              colors: const [Color(0x001B48), Color(0xFF80D8FF)],
              begin: Alignment.topRight, end: Alignment.bottomLeft,
            ),
          ),
          Positioned(
            top: 160, right: 30,
            child: _GradientBlob(
              width: 80, height: 80,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: 170, left: 120,
            child: _GradientBlob(
              width: 100, height: 100,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),

          // ── Konten utama ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w300)),
                      Text('Login!',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              height: 1.1)),
                    ],
                  ),
                ),

                const Spacer(),

                // Form card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1565C0).withOpacity(0.12),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username field
                      _buildInputField(
                        controller: _emailController,
                        label: 'Username',
                        hint: '',
                        keyboardType: TextInputType.emailAddress,
                        suffixColor: const Color(0xFF1565C0),
                      ),
                      const SizedBox(height: 40),

                      // Password field
                      _buildInputField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '',
                        obscure: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        suffixColor: const Color(0xFF9AA0B2),
                        onSuffixTap: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),

                      const SizedBox(height: 80),

                      // Tombol Masuk
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 8, 31, 78),
                                Color.fromARGB(255, 5, 35, 118),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 7, 72, 142)
                                    .withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Masuk',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
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
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    IconData? suffixIcon,
    Color suffixColor = const Color(0xFF9AA0B2),
    VoidCallback? onSuffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF2D3142),
              fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF9AA0B2),
                fontSize: 13,
                letterSpacing: obscure ? 3 : 0),
            filled: true,
            fillColor: const Color(0xFFF5F7FF),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: suffixColor, size: 20),
                  )
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E6FF), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUCCESS DIALOG — popup centang beranimasi
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessDialog extends StatefulWidget {
  const _SuccessDialog();

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _circleAnim;
  late Animation<double> _checkAnim;
  late Animation<double> _textAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Lingkaran hijau muncul duluan
    _circleAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    // Centang muncul setelah lingkaran
    _checkAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
    );

    // Teks muncul paling akhir
    _textAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();

    // Auto tutup setelah 2 detik
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 280,
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 40,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Lingkaran + centang animasi ──
              ScaleTransition(
                scale: _circleAnim,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran luar (glow)
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DBF8A).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Lingkaran dalam
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DBF8A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Ikon centang
                    ScaleTransition(
                      scale: _checkAnim,
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Teks ──
              FadeTransition(
                opacity: _textAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_textAnim),
                  child: Column(
                    children: [
                      Text(
                        'Login Berhasil!',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Selamat datang kembali 👋\nMengalihkan ke dashboard...',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9AA0B2),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Progress bar kecil
                      _AnimatedProgressBar(duration: const Duration(milliseconds: 2200)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROGRESS BAR di dalam success dialog
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedProgressBar extends StatefulWidget {
  final Duration duration;
  const _AnimatedProgressBar({required this.duration});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.linear);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: _anim.value,
          backgroundColor: const Color(0xFFF0F0F0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1DBF8A)),
          minHeight: 4,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GRADIENT BLOB WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _GradientBlob extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const _GradientBlob({
    required this.width,
    required this.height,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
        ),
      ),
    );
  }
}