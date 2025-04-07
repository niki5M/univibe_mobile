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

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is BottomNavSelectedState) {
          _selectedIndex = state.selectedIndex;
          _animationController.forward(from: 0.0);
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
              border: Border.all(color: ShadTheme.of(context).colorScheme.border, width: 1),
            ),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: _selectedIndex == 0 ? 0 : MediaQuery.of(context).size.width * 0.5,
                    right: _selectedIndex == 1 ? 0 : MediaQuery.of(context).size.width * 0.5,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: _buildNavItem(0, 'Schedule', Icons.calendar_month_outlined, context, isDarkMode)),
                      Expanded(child: _buildNavItem(1, 'Chat', Icons.email_outlined, context, isDarkMode)),
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

  Widget _buildNavItem(int index, String label, IconData icon, BuildContext context, bool isDarkMode) {
    final isSelected = _selectedIndex == index;
    final colorScheme = ShadTheme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        context.read<ScheduleBloc>().add(SelectBottomNavEvent(index));
        widget.onItemTapped(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? Colors.white : colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? (isDarkMode ? Colors.black : Colors.white) : (isDarkMode ? Colors.white70 : colorScheme.mutedForeground),
              size: 28,
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isSelected
                  ? SlideTransition(
                position: _textAnimation,
                child: Text(
                  label,
                  key: ValueKey<int>(index),
                  style: TextStyle(
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}