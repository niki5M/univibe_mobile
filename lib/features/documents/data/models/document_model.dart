// features/documents/data/models/document_model.dart
class Document {
  final String id;
  final String title;
  final DateTime orderedDate;
  final String status;

  Document({
    required this.id,
    required this.title,
    required this.orderedDate,
    required this.status,
  });
}