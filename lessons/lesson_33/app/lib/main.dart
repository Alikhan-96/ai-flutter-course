import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  String? userId;
  try {
    await Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final credential = await auth.signInAnonymously();
      userId = credential.user?.uid;
    } else {
      userId = auth.currentUser?.uid;
    }
    firebaseReady = true;
  } catch (_) {
    firebaseReady = false;
  }

  runApp(Lesson33App(firebaseReady: firebaseReady, userId: userId));
}

class Lesson33App extends StatelessWidget {
  const Lesson33App({
    super.key,
    required this.firebaseReady,
    required this.userId,
  });

  final bool firebaseReady;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final repository = firebaseReady && userId != null
        ? FirestoreNotesRepository(
            firestore: FirebaseFirestore.instance,
            userId: userId!,
          )
        : MockNotesRepository();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 33: Firestore Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: NotesHomePage(
        repository: repository,
        firebaseReady: firebaseReady && userId != null,
      ),
    );
  }
}

enum NoteStatus { todo, inProgress, done }

extension NoteStatusLabel on NoteStatus {
  String get label => switch (this) {
        NoteStatus.todo => 'To do',
        NoteStatus.inProgress => 'In progress',
        NoteStatus.done => 'Done',
      };
}

class NoteItem {
  const NoteItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final NoteStatus status;
  final List<String> tags;
  final DateTime createdAt;

  NoteItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    NoteStatus? status,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return NoteItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NoteItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final statusValue = data['status'] as String? ?? NoteStatus.todo.name;
    return NoteItem(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      status: NoteStatus.values.firstWhere(
        (value) => value.name == statusValue,
        orElse: () => NoteStatus.todo,
      ),
      tags: List<String>.from(data['tags'] as List<dynamic>? ?? const []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'status': status.name,
      'tags': tags,
      'searchTokens': _searchTokens,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  List<String> get _searchTokens {
    final raw = '$title $description $category ${tags.join(' ')}'
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9а-яё\s]'), ' ');
    return raw
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toSet()
        .toList();
  }
}

class NotesFilter {
  const NotesFilter({
    this.search = '',
    this.status,
    this.category,
  });

  final String search;
  final NoteStatus? status;
  final String? category;

  NotesFilter copyWith({
    String? search,
    Object? status = _sentinel,
    Object? category = _sentinel,
  }) {
    return NotesFilter(
      search: search ?? this.search,
      status: identical(status, _sentinel) ? this.status : status as NoteStatus?,
      category:
          identical(category, _sentinel) ? this.category : category as String?,
    );
  }
}

const _sentinel = Object();

abstract class NotesRepository {
  Stream<List<NoteItem>> watchNotes({
    required NotesFilter filter,
    required int limit,
  });

  Future<void> addNote(NoteItem note);
  Future<void> updateNote(NoteItem note);
  Future<void> deleteNote(String id);
}

class FirestoreNotesRepository implements NotesRepository {
  FirestoreNotesRepository({
    required FirebaseFirestore firestore,
    required this.userId,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final String userId;

  @override
  Stream<List<NoteItem>> watchNotes({
    required NotesFilter filter,
    required int limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId);

    if (filter.status != null) {
      query = query.where('status', isEqualTo: filter.status!.name);
    }

    if (filter.category != null && filter.category!.isNotEmpty) {
      query = query.where('category', isEqualTo: filter.category);
    }

    if (filter.search.trim().isNotEmpty) {
      query = query.where(
        'searchTokens',
        arrayContains: filter.search.trim().toLowerCase(),
      );
    }

    query = query.orderBy('createdAt', descending: true).limit(limit);

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(NoteItem.fromFirestore)
              .where((note) => note.userId == userId)
              .toList(),
        );
  }

  @override
  Future<void> addNote(NoteItem note) async {
    await _firestore.collection('notes').add(note.toFirestore());
  }

  @override
  Future<void> updateNote(NoteItem note) async {
    await _firestore.collection('notes').doc(note.id).update(note.toFirestore());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}

class MockNotesRepository implements NotesRepository {
  MockNotesRepository() {
    _items.addAll(
      List.generate(
        18,
        (index) => NoteItem(
          id: 'note-$index',
          userId: 'course-user-001',
          title: 'Task ${index + 1}',
          description: 'Homework task ${index + 1} for Firestore practice.',
          category: index.isEven ? 'Study' : 'Personal',
          status: NoteStatus.values[index % NoteStatus.values.length],
          tags: [
            index.isEven ? 'flutter' : 'firebase',
            if (index % 3 == 0) 'urgent',
          ],
          createdAt: DateTime.now().subtract(Duration(hours: index * 3)),
        ),
      ),
    );
    _emit();
  }

  final List<NoteItem> _items = [];
  final StreamController<List<NoteItem>> _controller =
      StreamController<List<NoteItem>>.broadcast();

  @override
  Stream<List<NoteItem>> watchNotes({
    required NotesFilter filter,
    required int limit,
  }) {
    return _controller.stream.map((items) {
      final filtered = items.where((note) {
        final matchesSearch = filter.search.trim().isEmpty ||
            note.title.toLowerCase().contains(filter.search.toLowerCase()) ||
            note.description
                .toLowerCase()
                .contains(filter.search.toLowerCase()) ||
            note.tags.contains(filter.search.toLowerCase());
        final matchesStatus =
            filter.status == null || note.status == filter.status;
        final matchesCategory =
            filter.category == null || note.category == filter.category;
        return matchesSearch && matchesStatus && matchesCategory;
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered.take(limit).toList();
    });
  }

  @override
  Future<void> addNote(NoteItem note) async {
    _items.add(note);
    _emit();
  }

  @override
  Future<void> updateNote(NoteItem note) async {
    final index = _items.indexWhere((item) => item.id == note.id);
    if (index >= 0) {
      _items[index] = note;
      _emit();
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    _items.removeWhere((item) => item.id == id);
    _emit();
  }

  void _emit() {
    _controller.add(List<NoteItem>.unmodifiable(_items));
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({
    super.key,
    required this.repository,
    required this.firebaseReady,
  });

  final NotesRepository repository;
  final bool firebaseReady;

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final _searchController = TextEditingController();
  var _filter = const NotesFilter();
  var _limit = 10;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 33: Notes CRUD'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
      ),
      body: Column(
        children: [
          if (!widget.firebaseReady)
            MaterialBanner(
              content: const Text(
                'Firebase is not configured in this repo, so the app is using mock live data. The Firestore implementation and security rules are included in the lesson.',
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by token/tag',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _limit = 10;
                      _filter = _filter.copyWith(search: value.trim());
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<NoteStatus?>(
                        value: _filter.status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                        ),
                        items: [
                          const DropdownMenuItem<NoteStatus?>(
                            value: null,
                            child: Text('All statuses'),
                          ),
                          ...NoteStatus.values.map(
                            (status) => DropdownMenuItem<NoteStatus?>(
                              value: status,
                              child: Text(status.label),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _limit = 10;
                            _filter = _filter.copyWith(status: value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _filter.category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: const [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All categories'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'Study',
                            child: Text('Study'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'Personal',
                            child: Text('Personal'),
                          ),
                          DropdownMenuItem<String?>(
                            value: 'Work',
                            child: Text('Work'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _limit = 10;
                            _filter = _filter.copyWith(category: value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<NoteItem>>(
              stream: widget.repository.watchNotes(
                filter: _filter,
                limit: _limit,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Stream error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notes = snapshot.data!;
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('No notes found for the selected filters.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: notes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == notes.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: FilledButton.tonal(
                          onPressed: () {
                            setState(() {
                              _limit += 10;
                            });
                          },
                          child: const Text('Load 10 more'),
                        ),
                      );
                    }

                    final note = notes[index];
                    return Card(
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          '${note.category} • ${note.status.label}\n${note.description}',
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await _openEditor(note: note);
                            }
                            if (value == 'delete') {
                              await widget.repository.deleteNote(note.id);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditor({NoteItem? note}) async {
    final titleController = TextEditingController(text: note?.title ?? '');
    final descriptionController =
        TextEditingController(text: note?.description ?? '');
    final tagsController = TextEditingController(text: note?.tags.join(', ') ?? '');
    var status = note?.status ?? NoteStatus.todo;
    var category = note?.category ?? 'Study';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(note == null ? 'New note' : 'Edit note'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(value: 'Study', child: Text('Study')),
                        DropdownMenuItem(
                          value: 'Personal',
                          child: Text('Personal'),
                        ),
                        DropdownMenuItem(value: 'Work', child: Text('Work')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            category = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NoteStatus>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: NoteStatus.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            status = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags',
                        hintText: 'firebase, flutter, urgent',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final item = NoteItem(
                      id: note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                      userId: widget.repository is FirestoreNotesRepository
                          ? (widget.repository as FirestoreNotesRepository).userId
                          : 'course-user-001',
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      category: category,
                      status: status,
                      tags: tagsController.text
                          .split(',')
                          .map((tag) => tag.trim().toLowerCase())
                          .where((tag) => tag.isNotEmpty)
                          .toList(),
                      createdAt: note?.createdAt ?? DateTime.now(),
                    );

                    if (note == null) {
                      await widget.repository.addNote(item);
                    } else {
                      await widget.repository.updateNote(item);
                    }

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
