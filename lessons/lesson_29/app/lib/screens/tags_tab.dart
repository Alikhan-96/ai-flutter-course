// tags_tab.dart
import 'package:flutter/material.dart';

import '../database/database.dart';
import 'add_edit_tag_dialog.dart';

class TagsTab extends StatelessWidget {
  final AppDatabase db;
  const TagsTab({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Tag>>(
        // watch() — reactive stream: rebuilds whenever tags table changes
        stream: db.watchAllTags(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final tags = snapshot.data ?? [];
          if (tags.isEmpty) {
            return const Center(
              child: Text('No tags yet.\nTap + to create one.',
                  textAlign: TextAlign.center),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: tags.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (ctx, i) {
              final tag = tags[i];
              return Dismissible(
                key: ValueKey(tag.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                        context: ctx,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete tag?'),
                          content: Text(
                              '"${tag.name}" will be removed from all tasks.'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, false),
                                child: const Text('Cancel')),
                            FilledButton(
                                onPressed: () =>
                                    Navigator.pop(ctx, true),
                                child: const Text('Delete')),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (_) => db.deleteTag(tag.id),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(tag.colorValue),
                      radius: 16,
                    ),
                    title: Text(tag.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showDialog(
                        context: ctx,
                        builder: (_) =>
                            AddEditTagDialog(db: db, existing: tag),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_tags',
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddEditTagDialog(db: db),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
