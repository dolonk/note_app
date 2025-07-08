import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/enum/note_enum.dart';
import '../view_models/dashboard_viewmodel.dart';
import '../../../data_layer/model/note_model.dart';
import 'package:note_app/features/note/provider/note_provider.dart';
import 'package:note_app/features/note/view_screens/widgets/note_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) {
        final viewModel = DashboardViewModel();
        viewModel.fetchNotes();
        viewModel.initSync();
        return viewModel;
      },
      child: Consumer2<NoteProvider, DashboardViewModel>(
        builder: (context, noteVm, vm, _) {
          final state = noteVm.fetchState;
          final notes = noteVm.notes;

          return Scaffold(
            appBar: AppBar(
              title: const Text('🗒️ My Notes'),
              actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => vm.fetchNotes())],
            ),
            body: _buildBody(state, notes, noteVm, vm),
          );
        },
      ),
    );
  }

  Widget _buildBody(NoteFetchState state, List<NoteModel> notes, NoteProvider noteVm, DashboardViewModel vm) {
    switch (state) {
      case NoteFetchState.loading:
        return const Center(child: CircularProgressIndicator());

      case NoteFetchState.success:
        return notes.isEmpty
            ? const Center(child: Text("No notes found."))
            : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                return NoteCard(note: note, onDelete: () => vm.deleteNote(note.id!));
              },
            );

      case NoteFetchState.error:
        return Center(child: Text(noteVm.error ?? "Unknown error"));

      default:
        return const SizedBox.shrink();
    }
  }
}
