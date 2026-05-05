import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/login/background_widget.dart';
import '../widgets/login/gradient_blob.dart';
import '../widgets/login/form_card_widget.dart';
import '../widgets/login/success_dialog.dart';
import '../utils/hash_helper.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure   = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      _showError('Username dan password harus diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final username      = _emailCtrl.text.trim();
      final inputPassword = _passwordCtrl.text.trim();
      final hashedInput   = hashPassword(inputPassword);

      debugPrint('=== DEBUG LOGIN ===');
      debugPrint('Username   : $username');
      debugPrint('Input pass : $inputPassword');
      debugPrint('Hash input : $hashedInput');
      debugPrint('Hash length: ${hashedInput.length}');

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('nama_pengguna', isEqualTo: username)
          .limit(1)
          .get();

      if (!mounted) return;

      if (query.docs.isEmpty) {
        setState(() => _isLoading = false);
        _showError('Username tidak ditemukan');
        return;
      }

      final userDoc = query.docs.first;
      final data    = userDoc.data();

      // ✅ trim() untuk buang whitespace/newline tersembunyi dari DB
      final savedPassword = (data['kata_sandi'] ?? '').toString().trim();
      final nama          = data['nama'] ?? username;

      debugPrint('DB kata_sandi  : "$savedPassword"');
      debugPrint('DB length      : ${savedPassword.length}');
      debugPrint('Hash length    : ${hashedInput.length}');
      debugPrint('Match plain    : ${savedPassword == inputPassword}');
      debugPrint('Match hash     : ${savedPassword == hashedInput}');
      debugPrint('All fields     : ${data.keys.toList()}');

      bool loginSuccess = false;

      // CASE 1: Password masih plain text → login + auto-upgrade ke hash
      if (savedPassword == inputPassword) {
        loginSuccess = true;
        await userDoc.reference.update({'kata_sandi': hashedInput});
        debugPrint('✅ Login via plain text → upgraded to hash');
      }
      // CASE 2: Password sudah hash SHA256
      else if (savedPassword == hashedInput) {
        loginSuccess = true;
        debugPrint('✅ Login via hash');
      } else {
        debugPrint('❌ Tidak match keduanya');
        debugPrint('Expected hash : $hashedInput');
        debugPrint('Saved in DB   : $savedPassword');
      }

      setState(() => _isLoading = false);

      if (loginSuccess) {
        await _showSuccessDialog(nama);
      } else {
        _showError('Password salah');
      }

    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(String username) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim, child: child),
      ),
      pageBuilder: (ctx, _, __) => const SuccessDialog(),
    );

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_in_user', username);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const MainPage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),

          const BlobWidget(
            top: -80, left: -60, width: 280, height: 280,
            colors: [Color(0x00001B48), Color(0xFFB3E5FC)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          const BlobWidget(
            top: 40, right: -30, width: 130, height: 130,
            colors: [Color(0x00001B48), Color(0xFF80D8FF)],
            begin: Alignment.topRight, end: Alignment.bottomLeft,
          ),
          const BlobWidget(
            top: 160, right: 30, width: 80, height: 80,
            colors: [Color(0x00001B48), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
          const BlobWidget(
            top: 170, left: 120, width: 100, height: 100,
            colors: [Color(0x00001B48), Color(0xFFB3E5FC)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Halo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Login!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.1,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                FormCardWidget(
                  emailCtrl:        _emailCtrl,
                  passwordCtrl:     _passwordCtrl,
                  obscure:          _obscure,
                  isLoading:        _isLoading,
                  onToggleObscure:  () => setState(() => _obscure = !_obscure),
                  onLogin:          _handleLogin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}