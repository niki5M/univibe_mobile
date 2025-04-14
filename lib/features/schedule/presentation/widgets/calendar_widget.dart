import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final appBarHeight = AppBar().preferredSize.height;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: appBarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Transform.scale(
                scale: 1.2,
                child: ShadCalendar(
                  selected: today,
                  fromMonth: DateTime(today.year - 1),
                  toMonth: DateTime(today.year, 12),
                  onChanged: (selectedDate) {
                    context.read<ScheduleBloc>().add(SelectDayEvent(selectedDate!));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}