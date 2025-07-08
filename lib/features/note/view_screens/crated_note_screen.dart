import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data_layer/model/note_model.dart';
import '../provider/note_provider.dart';
import '../../../utils/enum/note_enum.dart';
import '../view_models/create_note_viewmodel.dart';

class CreateNoteScreen extends StatelessWidget {
  final NoteModel? existingNote;
  const CreateNoteScreen({super.key, this.existingNote});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateNoteViewModel(existingNote),
      child: Consumer2<CreateNoteViewModel, NoteProvider>(
        builder: (context, vm, provider, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("➕ Create Note"), centerTitle: true),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: vm.titleController,
                    decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vm.contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vm.tagController,
                    decoration: const InputDecoration(labelText: 'Tags', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: vm.priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (value) => vm.priority = value!,
                    decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => vm.pickDate(context),
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            vm.reminderDate == null
                                ? "Pick Reminder Date"
                                : vm.reminderDate.toString().split(' ')[0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: vm.selectedColor, shape: BoxShape.circle),
                      ),
                      IconButton(
                        icon: const Icon(Icons.color_lens),
                        onPressed: () async {
                          final picked = await showDialog<Color>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
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
                          if (picked != null) vm.pickColor(picked);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed:
                        provider.operationState == NoteOperationState.creating
                            ? null
                            : () => vm.submitNote(context),
                    icon: const Icon(Icons.check),
                    label: Text(
                      provider.operationState == NoteOperationState.creating
                          ? "Saving..."
                          : (vm.existingNote != null ? "Update Note" : "Save Note"),
                    ),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
