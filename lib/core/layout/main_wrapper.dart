import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import '../init/theme/app_colors.dart';

class MainWrapper extends StatefulWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final index = _calculateSelectedIndex(context);
    if (_tabController.index != index) {
      _tabController.animateTo(index);
      setState(() {
        currentPage = index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/appointments')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index) {
    _tabController.animateTo(index);
    setState(() {
      currentPage = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/appointments');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double barWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(50),
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        showIcon: true,
        width: barWidth,
        barColor: AppColors.white,
        start: 2,
        end: 0,
        offset: 15,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 30,
        iconWidth: 30,
        reverse: false,
        hideOnScroll: false,
        body: (context, controller) => widget.child,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.midnightBlue,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: AppColors.midnightBlue.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicatorPadding: EdgeInsets.zero,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            indicator: FixedLineIndicator(
              color: AppColors.oldGold,
              width: 24,
              height: 4,
              bottomPadding: 0,
            ),
            onTap: (index) => _onItemTapped(index),
            tabs: [
              _buildTabItem(Icons.home_rounded, "Home", 0),
              _buildTabItem(Icons.calendar_month_rounded, "Appointment", 1),
              _buildTabItem(Icons.person_rounded, "Profile", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    final isSelected = currentPage == index;
    final activeColor = AppColors.oldGold;
    final inactiveColor = AppColors.white;

    return SizedBox(
      height: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? activeColor : inactiveColor,
            size: isSelected ? 28 : 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class FixedLineIndicator extends Decoration {
  final Color color;
  final double height;
  final double width;
  final double bottomPadding;

  const FixedLineIndicator({
    required this.color,
    this.height = 4,
    this.width = 20,
    this.bottomPadding = 0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FixedLinePainter(this, onChanged);
  }
}

class _FixedLinePainter extends BoxPainter {
  final FixedLineIndicator decoration;

  _FixedLinePainter(this.decoration, super.onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final Offset center =
        offset +
        Offset(
          configuration.size!.width / 2,
          configuration.size!.height -
              decoration.bottomPadding -
              decoration.height / 2,
        );

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: decoration.width,
        height: decoration.height,
      ),
      Radius.circular(decoration.height / 2),
    );

    canvas.drawRRect(rRect, paint);
  }
}
