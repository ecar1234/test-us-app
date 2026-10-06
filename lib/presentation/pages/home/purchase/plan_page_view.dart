import 'package:flutter/material.dart';
import 'package:test_us_app/presentation/pages/home/purchase/plans/free_plan.dart';
import 'package:test_us_app/presentation/pages/home/purchase/plans/premium_plan.dart';
import 'package:test_us_app/presentation/pages/home/purchase/plans/standard_plan.dart';

class PlanPageView extends StatefulWidget {
  const PlanPageView({super.key, required this.onPlanChanged});

  final ValueChanged<int> onPlanChanged;

  @override
  State<PlanPageView> createState() => _PlanPageViewState();
}

class _PlanPageViewState extends State<PlanPageView> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;

  int _currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex, viewportFraction: 0.8);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPageIndex = page;
        });
        widget.onPlanChanged.call(page);
      },
      itemBuilder: (context, idx) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 0.0;
            if (_pageController.position.haveDimensions) {
              value = (_pageController.page! - idx);
            } else {
              value = (_currentPageIndex.toDouble() - idx);
            }
            double scale = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Center(child: idx == 0 ? FreePlan() : (idx == 1 ? StandardPlan() : PremiumPlan())),
        );
      },
      itemCount: 3,
    );
  }
}
