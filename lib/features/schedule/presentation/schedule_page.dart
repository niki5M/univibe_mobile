import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uni_mobile/features/schedule/presentation/widgets/bottom_sheet_widget.dart';
import 'package:uni_mobile/features/schedule/presentation/widgets/calendar_widget.dart';
import '../../settings/presentation/widgets/setting_page.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_state.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedIndex = 0;
  final PanelController _panelController = PanelController();

  final List<Widget> _pages = [
    const CalendarWidget(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleBloc(),
      child: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is DaySelectedState) {
            _panelController.open();
          }
        },
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            SlidingUpPanel(
              controller: _panelController,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              panelBuilder: (sc) => ScheduleBottomPanel(scrollController: sc),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              backdropEnabled: false,
            ),
          ],
        ),
      ),
    );
  }
}