import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "ru_RU",
      rowHeight: 55,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600
        ),
        leftChevronIcon: _buildChevron(Icons.arrow_back_ios),
        rightChevronIcon: _buildChevron(Icons.arrow_forward_ios),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GoogleFonts.poppins(color: Colors.black26),
        weekendStyle: GoogleFonts.poppins(color: Colors.black45),
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2030),
      onDaySelected: (day, _) {
        context.read<ScheduleBloc>().add(SelectDayEvent(day));
      },
      selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: const Color(0xff715e67),
          borderRadius: BorderRadius.circular(14.0),
        ),
        selectedDecoration: BoxDecoration(
          color: const Color(0xffa68694),
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    );
  }

  Widget _buildChevron(IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Center(child: Icon(icon, color: Colors.black)),
    );
  }
}