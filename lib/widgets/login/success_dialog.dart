import 'package:flutter/material.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
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

    _circleAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _checkAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
    );
    _textAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();

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
              ScaleTransition(
                scale: _circleAnim,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1DBF8A).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 68, height: 68,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DBF8A),
                        shape: BoxShape.circle,
                      ),
                    ),
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
              FadeTransition(
                opacity: _textAnim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_textAnim),
                  child: Column(
                    children: [
                      const Text(
                        'Login Berhasil!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3142),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Selamat datang kembali 👋\nMengalihkan ke dashboard...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9AA0B2),
                          height: 1.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const _AnimatedProgressBar(
                        duration: Duration(milliseconds: 2200),
                      ),
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