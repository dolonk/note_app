import 'package:flutter/material.dart';
import '../../../../data_layer/model/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final void Function()? onTap;
  final VoidCallback onDelete;

  const NoteCard({super.key, required this.note, this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        onTap: onTap,
        title: Text(note.title),
        subtitle: Text(note.content),
        trailing: IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
      ),
    );
  }
}
