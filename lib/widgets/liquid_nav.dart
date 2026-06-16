import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/nav_item.dart';

class LiquidNav extends StatefulWidget {
  const LiquidNav({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<LiquidNav> createState() => _LiquidNavState();
}

class _LiquidNavState extends State<LiquidNav> {
  int activeIndex = 2;

  final List<NavItem> items = const [
    NavItem(icon: Icons.settings_rounded, label: 'إعدادات'),
    NavItem(icon: Icons.grid_view_rounded, label: 'الأقسام'),
    NavItem(icon: Icons.home_rounded, label: 'الرئيسية'),
  ];

  final List<GlobalKey> _keys = [];
  final GlobalKey _rowKey = GlobalKey();

  Rect? _pillRect;
  bool _pillAnimated = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < items.length; i++) {
      _keys.add(GlobalKey());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePill();
      _pillAnimated = true;
    });
  }

  void _updatePill() {
    final box =
        _keys[activeIndex].currentContext?.findRenderObject() as RenderBox?;
    final rowBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || rowBox == null) return;

    final offset = box.localToGlobal(Offset.zero, ancestor: rowBox);
    final rect = Rect.fromLTWH(offset.dx, 0, box.size.width, box.size.height);
    if (rect != _pillRect) {
      setState(() => _pillRect = rect);
    }
  }

  @override
  void didUpdateWidget(covariant LiquidNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePill());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final glassBg = isDark ? const Color(0x731E1E23) : const Color(0x26FFFFFF);
    final glassBorder = isDark
        ? const Color(0x26FFFFFF)
        : const Color(0x66FFFFFF);
    final pillBg = isDark ? const Color(0xCC3C3C41) : const Color(0xB3FFFFFF);
    final iconColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.5);
    final iconActive = isDark
        ? Colors.white
        : Colors.black.withValues(alpha: 0.95);
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.15);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isCompact = availableWidth < 360;
        final isTiny = availableWidth < 300;
        final btnHeight = isTiny ? 40.0 : 44.0;
        final fontSize = isTiny ? 13.0 : (isCompact ? 14.0 : 15.0);
        final iconSize = isTiny ? 18.0 : 20.0;
        final pillDuration = _pillAnimated
            ? const Duration(milliseconds: 900)
            : Duration.zero;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.1),
                blurRadius: 60,
                offset: const Offset(0, 30),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: glassBg,
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: widget.onToggleTheme,
                        child: SizedBox(
                          width: btnHeight,
                          height: btnHeight,
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) =>
                                  RotationTransition(
                                    turns: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  ),
                              child: Icon(
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                key: ValueKey(isDark),
                                size: iconSize,
                                color: iconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: dividerColor,
                    ),
                    Expanded(
                      child: Stack(
                        key: _rowKey,
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          if (_pillRect != null)
                            AnimatedPositioned(
                              duration: pillDuration,
                              curve: Curves.elasticOut,
                              left: _pillRect!.left,
                              top: 0,
                              child: AnimatedContainer(
                                duration: pillDuration,
                                curve: Curves.elasticOut,
                                width: _pillRect!.width,
                                height: btnHeight,
                                decoration: BoxDecoration(
                                  color: pillBg,
                                  borderRadius: BorderRadius.circular(99),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: isDark ? 0.4 : 0.08,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Row(
                            children: List.generate(items.length, (i) {
                              final item = items[i];
                              final active = i == activeIndex;
                              return Expanded(
                                key: _keys[i],
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() => activeIndex = i);
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                          (_) => _updatePill(),
                                        );
                                  },
                                  child: Container(
                                    height: btnHeight,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.label,
                                            maxLines: 1,
                                            softWrap: false,
                                            style:
                                                GoogleFonts.ibmPlexSansArabic(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.w600,
                                                  color: active
                                                      ? iconActive
                                                      : iconColor,
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            item.icon,
                                            size: iconSize,
                                            color: active
                                                ? iconActive
                                                : iconColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
