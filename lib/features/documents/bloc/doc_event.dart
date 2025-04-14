abstract class DocumentEvent {}

class LoadDocuments extends DocumentEvent {}

class RequestDocument extends DocumentEvent {
  final String documentTitle;

  RequestDocument(this.documentTitle);
}