// features/documents/bloc/document_state.dart
import '../data/models/document_model.dart';

abstract class DocumentState {}

class DocumentsLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<Document> availableDocuments;
  final List<Document> requestedDocuments;

  DocumentsLoaded({
    required this.availableDocuments,
    required this.requestedDocuments,
  });
}

class DocumentRequested extends DocumentState {}

class DocumentsError extends DocumentState {
  final String message;

  DocumentsError(this.message);
}