// bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../features/schedule/bloc/schedule_bloc.dart';
import '../../features/schedule/bloc/schedule_event.dart';
import '../../features/schedule/bloc/schedule_state.dart';
import '../../features/schedule/data/models/nav_item_model.dart';

const Color bottomNavBGColor = Color(0xfff3edf5);

class BottomNavBar extends StatefulWidget {
  final Function(int) onItemTapped;

  const BottomNavBar({super.key, required this.onItemTapped});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Флаг для запуска анимации
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = -1; // Изначально нет выбранного элемента
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        // Если состояние переключения индекса обновилось, то обновим _selectedIndex
        if (state is BottomNavSelectedState) {
          _selectedIndex = state.selectedIndex;
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bottomNavBGColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  bottomNavItems.length,
                      (index) {
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        context.read<ScheduleBloc>().add(
                          SelectBottomNavEvent(index),
                        );
                        widget.onItemTapped(index);
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xffb392a0) : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Transform.translate(
                          offset: isSelected
                              ? Offset(0, -10)
                              : Offset(0, 0),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: isSelected ? 1.2 : 1.0,
                            child: Lottie.asset(
                              bottomNavItems[index].lottie.src,
                              width: 80,
                              height: 80,
                              animate: isSelected,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}