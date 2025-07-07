import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/enum/note_enum.dart';
import '../../../core/di/service_locator.dart';
import '../view_models/dashboard_viewmodel.dart';
import '../../../data_layer/model/note_model.dart';
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
      child: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          final state = vm.provider.fetchState;
          final notes = vm.provider.notes;

          return Scaffold(
            appBar: AppBar(
              title: const Text('🗒️ My Notes'),
              actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => vm.fetchNotes())],
            ),
            body: _buildBody(state, notes, vm),
          );
        },
      ),
    );
  }

  Widget _buildBody(NoteFetchState state, List<NoteModel> notes, DashboardViewModel vm) {
    switch (state) {
      case NoteFetchState.loading:
        return const Center(child: CircularProgressIndicator());

      case NoteFetchState.success:
        // 🧾 Print all notes to console
        for (final note in notes) {
          debugPrint("📝 Note: ${note.toJson()}");
        }

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
        return Center(child: Text(vm.provider.error ?? "Unknown error"));

      default:
        return const SizedBox.shrink();
    }
  }
}
