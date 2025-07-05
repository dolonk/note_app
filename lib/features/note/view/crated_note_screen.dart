import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/service_locator.dart';
import '../../../data_layer/data_sources/remote/note_remote_datasource.dart';
import '../../../data_layer/model/note_model.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../utils/snackbar_toast/snack_bar.dart';
import '../provider/note_provider.dart';
import 'package:uuid/uuid.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();

  String _priority = 'Normal';
  Color _selectedColor = Colors.yellow.shade100;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    context.read<NoteProvider>().initializeAutoSync(userId);
  }


  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final tags = _tagController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      DSnackBar.warning(title: 'Title and Content are required');
      return;
    }

    final newNote = NoteModel(
      id: Uuid().v4(),
      userId: Supabase.instance.client.auth.currentUser?.id,
      title: title,
      content: content,
      tags: tags,
      priority: _priority,
      color: _selectedColor.value,
      reminderDate: _selectedDate,
      createdAt: DateTime.now(),
    );

    //_remoteUseCase.addNote(newNote);
    context.read<NoteProvider>().addNote(newNote);
  }

  void _resetForm() {
    _titleController.clear();
    _contentController.clear();
    _tagController.clear();
    setState(() {
      _priority = 'Normal';
      _selectedColor = Colors.yellow.shade100;
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (provider.operationState == NoteOperationState.success) {
    //     DSnackBar.success(title: "Note created successfully");
    //     _resetForm();
    //   } else if (provider.operationState == NoteOperationState.error) {
    //     DSnackBar.error(title: provider.error ?? 'Failed to create note');
    //   }
    // });

    return Scaffold(
      appBar: AppBar(title: const Text("➕ Create Note"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Tags (comma-separated)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _priority,
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                DropdownMenuItem(value: 'High', child: Text('High')),
              ],
              onChanged: (value) => setState(() => _priority = value!),
              decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(_selectedDate == null ? "Pick Reminder Date" : _selectedDate.toString().split(' ')[0]),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: _selectedColor, shape: BoxShape.circle),
                ),
                IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Pick Note Color"),
                            content: Wrap(
                              spacing: 10,
                              children:
                                  [
                                    Colors.red.shade100,
                                    Colors.green.shade100,
                                    Colors.blue.shade100,
                                    Colors.yellow.shade100,
                                    Colors.purple.shade100,
                                  ].map((color) {
                                    return GestureDetector(
                                      onTap: () => Navigator.pop(context, color),
                                      child: CircleAvatar(backgroundColor: color),
                                    );
                                  }).toList(),
                            ),
                          ),
                    );
                    if (color != null) {
                      setState(() => _selectedColor = color);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: provider.operationState == NoteOperationState.creating ? null : _submitNote,
              icon: const Icon(Icons.check),
              label:
                  provider.operationState == NoteOperationState.creating
                      ? const Text("Saving...")
                      : const Text("Save Note"),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
