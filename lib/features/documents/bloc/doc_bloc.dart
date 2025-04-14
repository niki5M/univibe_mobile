// features/documents/bloc/document_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_mobile/features/documents/data/models/document_model.dart';

import 'doc_event.dart';
import 'doc_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(DocumentsLoading()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<RequestDocument>(_onRequestDocument);
  }

  Future<void> _onLoadDocuments(
      LoadDocuments event,
      Emitter<DocumentState> emit,
      ) async {
    try {
      // логика загрузки данных из API (пока мокапы)
      final availableDocs = [
        Document(
          id: '1',
          title: 'Справка с места обучения',
          orderedDate: DateTime.now(),
          status: 'available',
        ),
        Document(
          id: '2',
          title: 'Справка о доходах',
          orderedDate: DateTime.now(),
          status: 'available',
        ),
        Document(
          id: '3',
          title: 'Справка с военкомата',
          orderedDate: DateTime.now(),
          status: 'available',
        ),
      ];

      final requestedDocs = [
        Document(
          id: '4',
          title: 'Справка с места обучения',
          orderedDate: DateTime(2025, 4, 10),
          status: 'ожидание',
        ),
        Document(
          id: '5',
          title: 'Справка с места обучения',
          orderedDate: DateTime(2025, 4, 10),
          status: 'готова',
        ),
      ];

      emit(DocumentsLoaded(
        availableDocuments: availableDocs,
        requestedDocuments: requestedDocs,
      ));
    } catch (e) {
      emit(DocumentsError('Ошибка загрузки документов'));
    }
  }

  Future<void> _onRequestDocument(
      RequestDocument event,
      Emitter<DocumentState> emit,
      ) async {
    try {
      // логика запроса документа
      // потом будет API-вызов
      emit(DocumentRequested());

      add(LoadDocuments());
    } catch (e) {
      emit(DocumentsError('Ошибка при запросе документа'));
    }
  }
}