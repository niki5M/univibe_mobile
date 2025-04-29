import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';

class GradebookScreen extends StatefulWidget {
  const GradebookScreen({super.key});

  @override
  State<GradebookScreen> createState() => _GradebookScreenState();
}

class _GradebookScreenState extends State<GradebookScreen> {
  int selectedSemester = 1;

  @override
  void initState() {
    super.initState();
    context.read<GradeBloc>().add(LoadGrades());
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    // final theme = ShadTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios_new)),
          title: Text(
            "Зачётная книжка",
            style: theme.textTheme.h4?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GradeBloc, GradeState>(
            builder: (context, state) {
              if (state is GradesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GradesError) {
                return Center(child: Text(state.message));
              }

              if (state is GradesLoaded) {
                final semesterRecords = state.records
                    .where((r) => r.semester == selectedSemester)
                    .toList();

                final semesterGrades = semesterRecords
                    .where((r) => r.grade != null)
                    .map((r) => r.grade!)
                    .toList();

                final diplomaGrades = state.records
                    .where((r) =>
                r.grade != null &&
                    r.examType.toLowerCase() == 'экзамен')
                    .map((r) => r.grade!)
                    .toList();

                final semesterAverage = semesterGrades.isNotEmpty
                    ? semesterGrades.reduce((a, b) => a + b) / semesterGrades.length
                    : 0;

                final diplomaAverageGrade = diplomaGrades.isNotEmpty
                    ? diplomaGrades.reduce((a, b) => a + b) / diplomaGrades.length
                    : 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShadCard(
                      radius: BorderRadius.circular(12),
                      shadows: [BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Text(
                                    "Средний балл за семестр",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.small?.copyWith(
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    textAlign: TextAlign.center,
                                    semesterAverage.toStringAsFixed(2),
                                    style: theme.textTheme.h4?.copyWith(
                                      color: const Color(0xFF6D58D0),
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 90,
                                child: VerticalDivider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    "Средний балл диплома",
                                    style: theme.textTheme.small?.copyWith(
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    textAlign: TextAlign.center,
                                    diplomaAverageGrade.toStringAsFixed(2),
                                    style: theme.textTheme.h4?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color: const Color(0xFF6D58D0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Семестр",
                      style: theme.textTheme.small?.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(12, (i) {
                          // SizedBox(width: 10);
                          if (i.isOdd) {
                            return SizedBox(width: 10);
                          } else {
                            final index = i ~/ 2;
                            final semester = index + 1;
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child: ChoiceChip(
                                label: Text(semester.toString()),
                                selected: semester == selectedSemester,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => selectedSemester = semester);
                                  }
                                },
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: semester == selectedSemester
                                      ? theme.brightness == Brightness.dark
                                      ? Colors.black
                                      : Colors.white
                                      : theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: semester == selectedSemester
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.border,
                                  ),
                                ),
                                backgroundColor: theme.brightness ==
                                    Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Успеваемость за $selectedSemester семестр",
                      style: theme.textTheme.large?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: semesterRecords.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final record = semesterRecords[index];
                          return ShadCard(
                            // shadows: [BoxShadow()],
                            border: const Border(
                              left: BorderSide(
                                width: 4,
                                color: Color(0xFF6D58D0),
                              ),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.subject,
                                    style: theme.textTheme.large?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    record.teacher,
                                    style: theme.textTheme.small?.copyWith(
                                      color:
                                      theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            size: 16,
                                            color: theme.colorScheme
                                                .mutedForeground,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Форма контроля: ${record.examType}",
                                            style: theme.textTheme.small,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_box_outlined,
                                            size: 16,
                                            color: theme.colorScheme
                                                .mutedForeground,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Семестр: ${record.semester}",
                                            style: theme.textTheme.small,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (record.grade != null) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Оценка: ${record.grade}",
                                            style: theme.textTheme.large,
                                          ),
                                        ),
                                        ShadBadge.new(
                                          backgroundColor: _getGradeColor(record.grade!),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          child: Text(
                                            _getGradeText(record.grade!),
                                            style: theme.textTheme.small?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.black : Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                  if (record.grade == null) ...[
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.muted,
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _getGradeText(record.grade!),
                                          style: theme.textTheme.small?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(int grade) {
    switch (grade) {
      case 2:
        return const Color(0xFFEE3838).withOpacity(0.9);
      case 5:
        return const Color(0xFF31C2BB).withOpacity(0.9);
      case 4:
        return const Color(0xFF6D58D0).withOpacity(0.9);
      case 3:
        return const Color(0xFFE5A93F).withOpacity(0.9);
      default:
        return const Color(0xFFCCCCCC).withOpacity(0.9);
    }
  }

  String _getGradeText(int grade) {
    switch (grade) {
      case 5:
        return "отлично";
      case 4:
        return "хорошо";
      case 3:
        return "удовлетворительно";
      case 2:
        return "неудовлетворительно";
      default:
        return "нет оценки";
    }
  }
}