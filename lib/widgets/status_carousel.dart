import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

// ── Model ─────────────────────────────────────────────────────────

class StatusCardData {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String value;
  final String label;
  final Color? accentColor;
  final VoidCallback? onTap; // navigasi saat kartu di-tap

  const StatusCardData({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.value,
    required this.label,
    this.accentColor,
    this.onTap,
  });
}

// ── StatusCarousel ────────────────────────────────────────────────

/// Horizontal auto-sliding carousel — style pill card (ikon + value + label).
/// - Auto slide setiap [autoPlayDuration]
/// - Swipe manual tetap bisa, timer reset otomatis
/// - Tampil 2 kartu per halaman, peek kartu berikutnya
/// - Dot indicator pill di bawah
class StatusCarousel extends StatefulWidget {
  final List<StatusCardData> items;
  final Duration autoPlayDuration;

  const StatusCarousel({
    super.key,
    required this.items,
    this.autoPlayDuration = const Duration(seconds: 3),
  });

  @override
  State<StatusCarousel> createState() => _StatusCarouselState();
}

class _StatusCarouselState extends State<StatusCarousel> {
  late final PageController _pageCtrl;
  Timer? _timer;

  static const _perPage = 1;
  int get _pageCount => (widget.items.length / _perPage).ceil();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayDuration, (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _pageCount;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cardH = r.isSmall ? 66.0 : 74.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // ── Carousel ──────────────────────────────────────────────
        SizedBox(
          height: cardH,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: _pageCount,
            onPageChanged: (p) {
              setState(() => _currentPage = p);
              _startAutoPlay();
            },
            itemBuilder: (_, pageIdx) {
              final start = pageIdx * _perPage;
              final end = (start + _perPage).clamp(0, widget.items.length);
              final pageItems = widget.items.sublist(start, end);

              return Row(
                children: List.generate(pageItems.length, (i) {
                  return Expanded(
                    child: _StatusChip(item: pageItems[i]),
                  );
                }),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ── Dot indicator + panah ──────────────────────────────────
        if (_pageCount > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Panah kiri
              _ArrowBtn(
                icon: Icons.chevron_left_rounded,
                onTap: _currentPage == 0 ? null : () => _animateTo(_currentPage - 1),
              ),

              const SizedBox(width: 6),

              // Dots — tap untuk loncat ke halaman itu
              ...List.generate(_pageCount, (i) {
                final isActive = i == _currentPage;
                return GestureDetector(
                  onTap: () => _animateTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.navy
                          : AppColors.grey.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),

              const SizedBox(width: 6),

              // Panah kanan
              _ArrowBtn(
                icon: Icons.chevron_right_rounded,
                onTap: _currentPage == _pageCount - 1 ? null : () => _animateTo(_currentPage + 1),
              ),
            ],
          ),
      ],
    );
  }

  void _animateTo(int page) {
    _pageCtrl.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    _startAutoPlay(); // reset timer
  }
}

// ── Tombol panah kiri/kanan ───────────────────────────────────────

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ArrowBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled ? 1.0 : 0.25,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.navy.withOpacity(0.08)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final StatusCardData item;
  const _StatusChip({required this.item});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final tappable = item.onTap != null;

    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: r.isSmall ? 12 : 14,
        vertical: r.isSmall ? 10 : 12,
      ),
      borderRadius: BorderRadius.circular(24),
      onTap: item.onTap,
      child: Row(
        children: [
          // ── Ikon bulat ──
          Container(
            width: r.isSmall ? 36 : 40,
            height: r.isSmall ? 36 : 40,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: item.iconColor,
              size: r.isSmall ? 16 : 18,
            ),
          ),

          SizedBox(width: r.isSmall ? 10 : 12),

          // ── Value + label ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: AppTextStyles.heading(r.scaledFont(20)).copyWith(
                    height: 1.1,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  item.label,
                  style: AppTextStyles.label(r.scaledFont(8.5)),
                ),
              ],
            ),
          ),

          // ── Panah kecil kalau tappable ──
          if (tappable)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.grey.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}