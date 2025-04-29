class GradeRecord {
  final String subject;
  final String teacher;
  final String examType;
  final int grade;
  final int semester;

  GradeRecord({
    required this.subject,
    required this.teacher,
    required this.examType,
    required this.grade,
    required this.semester,
  });

  factory GradeRecord.fromJson(Map<String, dynamic> json) {
    return GradeRecord(
      subject: json['subject'],
      teacher: json['teacher'],
      examType: json['exam_type'],
      grade: json['grade'],
      semester: json['semester'],
    );
  }
}