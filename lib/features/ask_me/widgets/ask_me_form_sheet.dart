import 'dart:io';
import 'package:academia/features/ask_me/bloc/ask_me_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AskMeFormSheet extends StatefulWidget {
  final BuildContext parentContext;
  const AskMeFormSheet({super.key, required this.parentContext});

  @override
  State<AskMeFormSheet> createState() => _AskMeFormSheetState();
}

class _AskMeFormSheetState extends State<AskMeFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  File? _selectedFile;
  String? _fileName;
  bool _isMultipleChoice = true;

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        // withData: true,
      );

      if (result != null) {
        final pickedFile = result.files.first;

        if (pickedFile.path == null) {
          throw Exception("File path is null.");
        }

        final fileSizeInBytes = pickedFile.size;
        const maxFileSizeInBytes = 10 * 1024 * 1024; // 10MB

        if (fileSizeInBytes > maxFileSizeInBytes) {
          throw Exception("File size exceeds the maximum limit of 10MB.");
        }

        final originalFile = File(pickedFile.path!);
        final appDocDir = await getApplicationDocumentsDirectory();
        final appDocPath = appDocDir.path;

        final uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
        final newPath = path.join(appDocPath, uniqueFileName);

        final copiedFile = await originalFile.copy(newPath);

        setState(() {
          _selectedFile = copiedFile;
          _fileName = copiedFile.path.split('/').last;
        });
      } else {
        // User cancelled the picker
        setState(() {
          _selectedFile = null;
        });

        if (!context.mounted) return;

        ScaffoldMessenger.of(widget.parentContext).showSnackBar(
          const SnackBar(content: Text("No file selected")),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      final title = _titleController.text.trim();
      final file = _selectedFile!;
      final userId = "123"; // will replace with the actual user ID later
      final multiChoice = _isMultipleChoice;
      final timeLimit = int.tryParse(_timeController.text.trim()) ?? 1;
      context.read<AskMeBloc>().add(GenerateQuestions(
          file: file,
          title: title,
          userId: userId,
          multiChoice: multiChoice,
          timeLimit: timeLimit));

    } else {
      ScaffoldMessenger.of(widget.parentContext).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocConsumer<AskMeBloc, AskMeState>(
      listener: (context, state) {
        print("Current AskMeBloc State: $state");
        if (state is AskMeErrorState) {
          print("Error: ${state.error}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is QuestionState) {
          context.pushNamed("ask-me-questions");
        }
      },
      builder: (context, state) {
        final isLoading = state is AskMeLoadingState;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 8,
            bottom: 8,
            top: 8,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Title",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter a title" : null,
                ),
                const SizedBox(height: 10),
                Text(
                  "Select a PDF file to upload (Max 10MB):",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload file")),
                ),
                const SizedBox(height: 5),
                if (_selectedFile != null) Text("$_fileName"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ChoiceChip(
                        label: Text("Multiple Choice"),
                        selected: _isMultipleChoice,
                        onSelected: (bool selected) {
                          setState(() {
                            _isMultipleChoice = true;
                          });
                        },
                        selectedColor: theme.colorScheme.tertiaryContainer,
                        backgroundColor: theme.colorScheme.secondaryContainer),
                    SizedBox(width: 5),
                    ChoiceChip(
                        label: Text("True/False"),
                        selected: !_isMultipleChoice,
                        onSelected: (bool selected) {
                          setState(() {
                            _isMultipleChoice = false;
                          });
                        },
                        selectedColor: theme.colorScheme.tertiaryContainer,
                        backgroundColor: theme.colorScheme.secondaryContainer),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Set Quiz Time (in minutes):",
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter time between 1 - 30 minutes",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final intVal = int.tryParse(value ?? '');
                    if (intVal == null || intVal < 1 || intVal > 30) {
                      return "Please choose between 1 and 30 minutes";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                isLoading
                    ? CircularProgressIndicator()
                    : OutlinedButton.icon(
                        onPressed: () => _submit(),
                        label: Text("Generate Questions",
                            style: theme.textTheme.labelLarge),
                        icon: Icon(Icons.quiz),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
