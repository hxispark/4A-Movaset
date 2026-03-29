import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background putih/abu sangat terang ──
          Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 5, 35, 118), // biru sangat gelap (atas)
        Color.fromARGB(255, 8, 31, 78), // biru tengah
        Color.fromARGB(255, 11, 54, 97), // biru terang bawah
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
),

          // ── Blob besar kiri atas ──
          Positioned(
            top: -80,
            left: -60,
            child: _GradientBlob(
              width: 280,
              height: 280,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          // ── Blob kecil kanan atas ──
          Positioned(
            top: 40,
            right: -30,
            child: _GradientBlob(
              width: 130,
              height: 130,
              colors: const [Color(0x001B48), Color(0xFF80D8FF)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),

          // ── Blob sedang tengah-kanan ──
          Positioned(
            top: 160,
            right: 30,
            child: _GradientBlob(
              width: 80,
              height: 80,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          Positioned(
            top: 170,
            left: 120,
            child: _GradientBlob(
              width: 100,
              height: 100,
              colors: const [Color(0x001B48), Color(0xFFB3E5FC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          // ── Konten utama ──
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header teks ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
  'Halo',
  style: GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 38,
    fontWeight: FontWeight.w300,
  ),
),
                      Text(
                        'Login!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Form card putih ──
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 68),
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

                      const SizedBox(height: 20),

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
                        onSuffixTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1565C0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // SIGN IN button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 8, 31, 78), Color.fromARGB(255, 5, 35, 118)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 7, 72, 142).withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
  if (_emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Username dan password harus diisi')),
    );
  }
},
                            
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
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

                      const SizedBox(height: 20),

                      // Don't have account
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            text: "",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9AA0B2),
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: '',
                                style: TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w700,
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
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
  fontSize: 14,
  color: const Color(0xFF2D3142),
  fontWeight: FontWeight.w400,
),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: const Color(0xFF9AA0B2),
              fontSize: 13,
              letterSpacing: obscure ? 3 : 0,
            ),
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
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E6FF), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF1565C0), width: 1.5),
            ),
          ),
        ),
      ],
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