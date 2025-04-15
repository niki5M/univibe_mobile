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
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.border,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _buildNavItem(0, Icons.home_outlined, 'Главная', context),
                  _buildNavItem(1, Icons.calendar_today_outlined, 'Расписание', context),
                  _buildNavItem(2, Icons.description_outlined, 'Документы', context),
                  _buildNavItem(3, Icons.person_outlined, 'Профиль', context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, BuildContext context) {
    final theme = ShadTheme.of(context);
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
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
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}