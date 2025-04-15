import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_mobile/features/schedule/presentation/widgets/bottom_sheet_widget.dart';
import 'package:uni_mobile/features/schedule/presentation/widgets/calendar_widget.dart';
import '../../../core/widgets/bottom_nav_bar.dart';

import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_state.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const CalendarWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ScheduleBloc(),
        child: BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is DaySelectedState) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    // color: Colors.transparent,
                    child: Stack(
                      children: [
                        ScheduleModalSheet(groupName: "И-1-22(а)"),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: BottomNavBar(
                            onItemTapped: (index) {
                              // Handle navigation
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
          child: Stack(
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ],
          ),
        ),
      ),
    );
  }
}