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
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    // final colorScheme = ShadTheme.of(context).colorScheme;

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is BottomNavSelectedState) {
          _selectedIndex = state.selectedIndex;
        }

        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xff0a1429) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
              border: Border.all(
                color: ShadTheme.of(context).colorScheme.border,
                width: 1,
              ),
            ),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: _getIndicatorPosition(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 32,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      _buildNavItem(0, Icons.calendar_month_outlined, context, isDarkMode),
                      _buildNavItem(1, Icons.email_outlined, context, isDarkMode),
                      _buildNavItem(2, Icons.person_outline, context, isDarkMode),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _getIndicatorPosition(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (_selectedIndex * (width / 3)) + (width / 3 - (width / 3 - 32)) / 2 - 16;
  }

  Widget _buildNavItem(int index, IconData icon, BuildContext context, bool isDarkMode) {
    final isSelected = _selectedIndex == index;
    final colorScheme = ShadTheme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ScheduleBloc>().add(SelectBottomNavEvent(index));
          widget.onItemTapped(index);

          if (index == 0) {
            Navigator.pushNamed(context, '/schedule');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/documents');
          } else if (index == 2) {

          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? (isDarkMode ? Colors.black : Colors.white)
                : (isDarkMode ? Colors.white70 : colorScheme.mutedForeground),
            size: 28,
          ),
        ),
      ),
    );
  }
}