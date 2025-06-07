// lib/screens/my_recordings_screen.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:personal_test/localization/app_localizations.dart';
import 'package:path/path.dart' as p;

class MyRecordingsScreen extends StatefulWidget {
  const MyRecordingsScreen({
    super.key,
    });

  @override
  State<MyRecordingsScreen> createState() => _MyRecordingsScreenState();
}

class _MyRecordingsScreenState extends State<MyRecordingsScreen> {
  List<FileSystemEntity> _recordingFiles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingFilePath;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        if (state == PlayerState.completed) {
          setState(() {
            _isPlaying = false;
            _currentlyPlayingFilePath = null;
          });
        }
      }
    });
  }

  Future<void> _loadRecordings() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final directory = Directory(appDocDir.path);

      if (await directory.exists()) {
        final allFiles = directory.listSync().where((file) =>
            file.path.endsWith('.wav')).toList();

        // 🌟 수정된 부분: 파일 이름이 'user_voice_'로 시작하는 파일은 제외
        final filteredFiles = allFiles.where((file) {
          final fileName = p.basename(file.path);
          return !fileName.startsWith('user_voice_');
        }).toList();

        setState(() {
          _recordingFiles = filteredFiles;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading recordings: $e')), // 이 부분도 로컬라이제이션 고려
        );
      }
    }
  }

  // 나머지 코드는 동일합니다.
  // _playRecording, _deleteRecording, _renameRecording, _getFileName, _getFileNameWithoutExtension, dispose, build 메서드
  Future<void> _playRecording(String filePath) async {
    final localizations = AppLocalizations.of(context)!;
    if (_isPlaying && _currentlyPlayingFilePath == filePath) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
        _currentlyPlayingFilePath = null;
      });
    } else {
      await _audioPlayer.stop();
      try {
        await _audioPlayer.play(DeviceFileSource(filePath));
        setState(() {
          _isPlaying = true;
          _currentlyPlayingFilePath = filePath;
        });
      } catch (e) {
        setState(() {
          _isPlaying = false;
          _currentlyPlayingFilePath = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('filePlaybackError', {'errorMessage': e.toString()}))),
        );
        print('ERROR _playRecording: $e');
      }
    }
  }

  Future<void> _deleteRecording(String filePath) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        if (_currentlyPlayingFilePath == filePath) {
          await _audioPlayer.stop();
          setState(() {
            _isPlaying = false;
            _currentlyPlayingFilePath = null;
          });
        }
        _loadRecordings();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('fileDeleted'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('fileDeletionFailed', {'errorMessage': e.toString()}))),
      );
      print('ERROR _deleteRecording: $e');
    }
  }

  Future<void> _renameRecording(String oldPath, String newName) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        final appDocDir = await getApplicationDocumentsDirectory();
        String originalExtension = p.extension(oldPath);
        String finalNewName = newName;

        if (!newName.contains('.')) {
          finalNewName = '$newName$originalExtension';
        }

        final newPath = '${appDocDir.path}/$finalNewName';

        await oldFile.rename(newPath);
        _loadRecordings();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('fileRenamed'))),
        );
        if (_currentlyPlayingFilePath == oldPath) {
          setState(() {
            _currentlyPlayingFilePath = newPath;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('fileRenameFailed', {'errorMessage': e.toString()}))),
      );
      print('ERROR _renameRecording: $e');
    }
  }

  String _getFileName(String path) {
    return p.basename(path);
  }

  String _getFileNameWithoutExtension(String path) {
    return p.basenameWithoutExtension(path);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('myRecordings'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: _recordingFiles.isEmpty
          ? Center(
        child: Text(
          localizations.translate('noSavedRecordings'),
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _recordingFiles.length,
        itemBuilder: (context, index) {
          final file = _recordingFiles[index];
          final fileName = _getFileName(file.path);
          final fileNameWithoutExt = _getFileNameWithoutExtension(file.path);
          final isCurrentlyPlaying = _currentlyPlayingFilePath == file.path;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: ListTile(
              leading: Icon(
                isCurrentlyPlaying && _isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: isCurrentlyPlaying && _isPlaying ? Colors.orange : Colors.lightBlue,
                size: 40,
              ),
              title: Text(
                fileName,
                style: TextStyle(
                  fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentlyPlaying ? Colors.lightBlue : Colors.black,
                ),
              ),
              subtitle: Text(
                '${file.statSync().size ~/ 1024} KB',
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () => _playRecording(file.path),
              onLongPress: () {
                TextEditingController renameController = TextEditingController(text: fileNameWithoutExt);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.translate('renameRecording')),
                    content: TextField(
                      controller: renameController,
                      decoration: InputDecoration(
                        hintText: localizations.translate('enterNewFileName'),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(localizations.translate('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          if (renameController.text.isNotEmpty) {
                            _renameRecording(file.path, renameController.text);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.translate('rename')),
                      ),
                    ],
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.translate('deleteRecording')),
                    content: Text(localizations.translate('confirmDeleteRecording', {'fileName': fileName})),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(localizations.translate('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteRecording(file.path);
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations.translate('delete'), style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}