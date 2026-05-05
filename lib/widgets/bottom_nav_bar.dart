import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Bottom navigation bar utama Movaset.
/// Index: 0=Dashboard  1=Aset  2=Live  3=Notifikasi  4=Analitik
class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTab;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTab,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _levitateCtrl;
  late Animation<double> _levitateAnim;
  late Animation<double> _fadeAnim;

  final List<GlobalKey> _tabKeys = List.generate(5, (_) => GlobalKey());

  double _orbLeft = 0;
  bool _measured = false;

  @override
  void initState() {
    super.initState();

    _levitateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _levitateAnim = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _levitateCtrl, curve: Curves.easeOutCubic),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _levitateCtrl, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _snapOrbToTab(widget.currentIndex, animate: false);
      _levitateCtrl.forward();
    });
  }

  @override
  void didUpdateWidget(BottomNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _levitateCtrl.animateBack(
        0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeIn,
      ).then((_) {
        if (!mounted) return;
        _snapOrbToTab(widget.currentIndex, animate: true);
        _levitateCtrl.animateTo(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _levitateCtrl.dispose();
    super.dispose();
  }

  void _snapOrbToTab(int idx, {required bool animate}) {
    final key = _tabKeys[idx];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final navBox = context.findRenderObject() as RenderBox?;
    if (box == null || navBox == null) return;

    final localOffset = box.localToGlobal(Offset.zero, ancestor: navBox);
    final center = localOffset.dx + box.size.width / 2;

    setState(() {
      _orbLeft = center - 22.0;
      _measured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final navH = r.isSmall ? 54.0 : 64.0;
    const orbSize = 44.0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navy,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: navH,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // ── 5 tab sejajar ──
              Row(
                children: [
                  _NavItem(
                    key: _tabKeys[0],
                    icon: Icons.manage_search_rounded,
                    label: 'Beranda',
                    index: 0,
                    current: widget.currentIndex,
                    onTap: widget.onTab,
                  ),
                  _NavItem(
                    key: _tabKeys[1],
                    icon: Icons.inventory_2_outlined,
                    label: 'Aset',
                    index: 1,
                    current: widget.currentIndex,
                    onTap: widget.onTab,
                  ),
                  _NavItem(
                    key: _tabKeys[2],
                    icon: Icons.location_on_outlined,
                    label: 'Langsung',
                    index: 2,
                    current: widget.currentIndex,
                    onTap: widget.onTab,
                  ),
                  _NavItem(
                    key: _tabKeys[3],
                    icon: Icons.notifications_outlined,
                    label: 'Notifikasi',
                    index: 3,
                    current: widget.currentIndex,
                    onTap: widget.onTab,
                  ),
                  _NavItem(
                    key: _tabKeys[4],
                    icon: Icons.bar_chart_rounded,
                    label: 'Analitik',
                    index: 4,
                    current: widget.currentIndex,
                    onTap: widget.onTab,
                  ),
                ],
              ),

              // ── Lingkaran oranye sliding + levitate + fade ──
              if (_measured)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
                  left: _orbLeft,
                  top: (navH - orbSize) / 2,
                  child: AnimatedBuilder(
                    animation: _levitateCtrl,
                    builder: (context, child) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _levitateAnim.value),
                        child: child,
                      ),
                    ),
                    child: _MovingOrb(
                      size: orbSize,
                      index: widget.currentIndex,
                      onTap: widget.onTab,
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

// ── Lingkaran oranye ──────────────────────────────────────────────

class _MovingOrb extends StatelessWidget {
  final double size;
  final int index;
  final ValueChanged<int> onTap;

  const _MovingOrb({
    required this.size,
    required this.index,
    required this.onTap,
  });

  static const _icons = [
    Icons.manage_search_rounded,   // 0 – Dashboard
    Icons.inventory_2_rounded,     // 1 – Aset
    Icons.location_on_rounded,     // 2 – Live
    Icons.notifications_rounded,   // 3 – Notifikasi
    Icons.bar_chart_rounded,       // 4 – Analitik
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.orange,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orange.withOpacity(0.55),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 190),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.65, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          ),
          child: Icon(
            _icons[index],
            key: ValueKey(index),
            color: Colors.white,
            size: size * 0.44,
          ),
        ),
      ),
    );
  }
}

// ── Tab item ──────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  bool get _isSelected => current == index;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: r.isSmall ? 7 : 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _isSelected ? 0.0 : 1.0,
                child: Icon(
                  icon,
                  color: Colors.white38,
                  size: r.scaledIcon(20),
                ),
              ),
              SizedBox(height: r.isSmall ? 3 : 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: _isSelected ? Colors.white : Colors.white38,
                  fontSize: r.scaledFont(r.isSmall ? 8.0 : 9.0),
                  fontWeight:
                      _isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}