import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../features/schedule/bloc/schedule_bloc.dart';
import '../../features/schedule/bloc/schedule_event.dart';
import '../../features/schedule/bloc/schedule_state.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onItemTapped;

  const BottomNavBar({super.key, required this.onItemTapped});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is BottomNavSelectedState) {
          _selectedIndex = state.selectedIndex;
        }

        return Container(
          // padding: EdgeInsets.all(),
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: colorScheme.border,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 72,
              child: Row(
                children: [
                  _buildNavItem(0, LucideIcons.layoutDashboard, context),
                  _buildNavItem(1, LucideIcons.user, context),
                  _buildNavItem(2, LucideIcons.fileChartColumnIncreasing, context),
                  _buildNavItem(3, LucideIcons.bookOpenCheck, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            context.read<ScheduleBloc>().add(SelectBottomNavEvent(index));
            widget.onItemTapped(index);

            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/schedule');
                break;
              case 2:
                Navigator.pushNamed(context, '/documents');
                break;
              case 3:
                Navigator.pushNamed(context, '/gradbook');
                break;
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(55),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}