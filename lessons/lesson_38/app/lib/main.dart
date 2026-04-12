import 'package:flutter/material.dart';

import 'data/datasources/notes_local_data_source.dart';
import 'data/datasources/notes_remote_data_source.dart';
import 'data/repositories/notes_repository_impl.dart';
import 'domain/entities/note.dart';
import 'domain/repositories/notes_repository.dart';

void main() {
  runApp(const Lesson38App());
}

class Lesson38App extends StatelessWidget {
  const Lesson38App({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = NotesRepositoryImpl(
      remoteDataSource: DemoNotesRemoteDataSource(),
      localDataSource: InMemoryNotesLocalDataSource(
        seedNotes: <Note>[
          const Note(
            id: 'cached-1',
            title: 'Cached architecture note',
            content: 'Loaded locally before the remote refresh finishes.',
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lesson 38: Repository + Adapter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: NotesRepositoryDemoPage(repository: repository),
    );
  }
}

class NotesRepositoryDemoPage extends StatefulWidget {
  const NotesRepositoryDemoPage({required this.repository, super.key});

  final NotesRepository repository;

  @override
  State<NotesRepositoryDemoPage> createState() =>
      _NotesRepositoryDemoPageState();
}

class _NotesRepositoryDemoPageState extends State<NotesRepositoryDemoPage> {
  List<Note> _notes = const <Note>[];
  String _status = 'Ready to load notes';
  FetchStrategy _selectedStrategy = FetchStrategy.localFirst;
  bool _simulateRemoteFailure = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final repository = widget.repository;

    if (repository is NotesRepositoryImpl) {
      repository.remoteDataSource.shouldFail = _simulateRemoteFailure;
    }

    setState(() {
      _status = _selectedStrategy == FetchStrategy.localFirst
          ? 'Loading cached notes first, then refreshing from remote...'
          : 'Loading notes using ${_selectedStrategy.label} strategy...';
    });

    if (_selectedStrategy == FetchStrategy.localFirst) {
      final cachedNotes = await repository.getNotes(
        strategy: FetchStrategy.cacheOnly,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _notes = cachedNotes;
        _status = cachedNotes.isEmpty
            ? 'No local cache yet, requesting remote data...'
            : 'Showing local cache first (${cachedNotes.length} items)';
      });

      try {
        final refreshedNotes = await repository.refreshNotes();

        if (!mounted) {
          return;
        }

        setState(() {
          _notes = refreshedNotes;
          _status =
              'Remote refresh complete, cache updated (${refreshedNotes.length} items)';
        });
      } catch (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _status = 'Remote refresh failed, cached notes remain visible';
        });
      }

      return;
    }

    try {
      final notes = await repository.getNotes(strategy: _selectedStrategy);

      if (!mounted) {
        return;
      }

      setState(() {
        _notes = notes;
        _status = _selectedStrategy == FetchStrategy.remoteFirst
            ? 'Remote-first load completed (${notes.length} items)'
            : 'Cache-only load completed (${notes.length} items)';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson 38: Repository + Adapter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This lesson separates domain models, DTOs, mappers, '
                'datasources, and repository logic. The screen also shows the '
                'homework caching flow: local cache first, then remote update.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fetch strategy',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<FetchStrategy>(
                    value: _selectedStrategy,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: FetchStrategy.values
                        .map(
                          (strategy) => DropdownMenuItem<FetchStrategy>(
                            value: strategy,
                            child: Text(strategy.label),
                          ),
                        )
                        .toList(),
                    onChanged: (strategy) {
                      if (strategy == null) {
                        return;
                      }

                      setState(() {
                        _selectedStrategy = strategy;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _simulateRemoteFailure,
                    title: const Text('Simulate remote datasource failure'),
                    subtitle: const Text(
                      'Useful for checking repository fallback behavior',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _simulateRemoteFailure = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _loadNotes,
                    child: const Text('Load notes'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.layers_outlined),
              title: const Text('Repository status'),
              subtitle: Text(_status),
            ),
          ),
          const SizedBox(height: 16),
          ..._notes.map(
            (note) => Card(
              child: ListTile(
                leading: const Icon(Icons.note_alt_outlined),
                title: Text(note.title),
                subtitle: Text('${note.content}\nDomain id: ${note.id}'),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
