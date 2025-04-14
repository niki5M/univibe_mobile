import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/auth/bloc/auth_bloc.dart';
import '../../../core/auth/bloc/auth_state.dart';
import '../bloc/doc_bloc.dart';
import '../bloc/doc_event.dart';
import '../bloc/doc_state.dart';
import '../data/models/document_model.dart';


class DocMainScreen extends StatefulWidget {
  const DocMainScreen({super.key});

  @override
  State<DocMainScreen> createState() => _DocMainScreenState();
}

class _DocMainScreenState extends State<DocMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _groupController = TextEditingController();
  final _birthDateController = TextEditingController();
  // bool _hasScholarship = false;
  // bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    context.read<DocumentBloc>().add(LoadDocuments());
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final userProfile = authState.userProfile;
      if (userProfile != null) {
        // Заполняем ФИО из профиля
        final givenName = userProfile['given_name'] ?? '';
        final familyName = userProfile['family_name'] ?? '';
        final fullName = '$familyName $givenName'.trim();
        if (fullName.isNotEmpty) {
          _fullNameController.text = fullName;
        }

        // Заполняем группу из атрибутов пользователя
        final group = userProfile['groups']?.firstOrNull ??
            userProfile['group'] ??
            userProfile['attributes']?['group']?.firstOrNull;
        if (group != null && group is String) {
          _groupController.text = group;
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _groupController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DocumentsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: theme.colorScheme.foreground),
              ),
            );
          }

          if (state is DocumentsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Заказать справку',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAvailableDocuments(state.availableDocuments, theme),
                  const SizedBox(height: 24),
                  Text(
                    'Статусы заявок',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRequestedDocuments(state.requestedDocuments, theme),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // Остальные методы остаются без изменений
  Widget _buildAvailableDocuments(List<Document> documents, ShadThemeData theme) {
    return Column(
      children: documents.map((doc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(71),
              side: BorderSide(
                color: theme.colorScheme.border,
                width: 1,
              ),
            ),
            child: SizedBox(
              height: 60,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                minVerticalPadding: 0,
                dense: true,
                title: Text(
                  doc.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.foreground,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: theme.colorScheme.mutedForeground,
                ),
                onTap: () => _showRequestDialog(context, doc),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showRequestDialog(BuildContext context, Document document) {
    final theme = ShadTheme.of(context);
    String? scholarshipChoice;
    String? termsAccepted;
    final _copiesController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog(
            backgroundColor: theme.colorScheme.background,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: theme.colorScheme.border,
                width: 1,
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return Form(
                  key: _formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.99,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Справка об обучении',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.foreground,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  LucideIcons.x,
                                  size: 20,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Для заказа справки с места обучения необходимо заполнить следующую форму:',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('ФИО'),
                          ShadInput(controller: _fullNameController),
                          const SizedBox(height: 10),
                          _buildLabel('Дата рождения'),
                          ShadInput(controller: _birthDateController),
                          const SizedBox(height: 10),
                          _buildLabel('Группа'),
                          ShadInput(controller: _groupController),
                          const SizedBox(height: 10),
                          _buildLabel('Какое количество справок Вам необходимо?'),
                          ShadInput(controller: _copiesController),
                          const SizedBox(height: 10),
                          _buildLabel('Получаете ли вы стипендию?'),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Да',
                                groupValue: scholarshipChoice,
                                onChanged: (value) {
                                  setModalState(() {
                                    scholarshipChoice = value!;
                                  });
                                },
                              ),
                              const Text('Да'),
                              const SizedBox(width: 16),
                              Radio<String>(
                                value: 'Нет',
                                groupValue: scholarshipChoice,
                                onChanged: (value) {
                                  setModalState(() {
                                    scholarshipChoice = value!;
                                  });
                                },
                              ),
                              const Text('Нет'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('Даю согласие на обработку персональных данных'),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Да',
                                groupValue: termsAccepted,
                                onChanged: (value) {
                                  setModalState(() {
                                    termsAccepted = value!;
                                  });
                                },
                              ),
                              const Text('Да'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ShadButton(
                              width: double.infinity,
                              child: const Text('Подать заявку'),
                              onPressed: () {
                                if (termsAccepted != 'Да') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Необходимо согласие на обработку данных'),
                                      backgroundColor: theme.colorScheme.destructive,
                                    ),
                                  );
                                  return;
                                }
                                context.read<DocumentBloc>().add(
                                  RequestDocument(document.title),
                                );

                                _fullNameController.clear();
                                _birthDateController.clear();
                                _groupController.clear();
                                _copiesController.clear();

                                setModalState(() {
                                  scholarshipChoice = null;
                                  termsAccepted = null;
                                });

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Заявка на ${document.title} отправлена'),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildRequestedDocuments(List<Document> documents, ShadThemeData theme) {
    final dateFormat = DateFormat('d MMMM, y', 'ru_RU');

    return Column(
      children: documents.map((doc) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: theme.colorScheme.border,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.foreground,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Статус заявки: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: doc.status == 'готова'
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            doc.status,
                            style: TextStyle(
                              fontSize: 14,
                              color: doc.status == 'готова'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (doc.status != 'готова')
                      Icon(
                        LucideIcons.loader,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                    if (doc.status == 'готова')
                      Icon(
                        LucideIcons.circleCheckBig,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.calendarDays,
                      size: 16,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Заказана: ${dateFormat.format(doc.orderedDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}