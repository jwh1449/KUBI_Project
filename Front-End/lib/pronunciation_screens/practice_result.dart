// lib/practice_result.dart
class PracticeResult {
  final int? id;
  final String correctText;
  final String recognizedText;
  final double? cer;
  final double? mfccSimilarity;
  final DateTime timestamp;
  final String? recognizedAudioPath;

  PracticeResult({
    this.id,
    required this.correctText,
    required this.recognizedText,
    this.cer,
    this.mfccSimilarity,
    required this.timestamp,
    this.recognizedAudioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'correctText': correctText,
      'recognizedText': recognizedText,
      'cer': cer,
      'mfccSimilarity': mfccSimilarity,
      'timestamp': timestamp.toIso8601String(),
      'recognizedAudioPath': recognizedAudioPath,
    };
  }

  factory PracticeResult.fromMap(Map<String, dynamic> map) {
    return PracticeResult(
      id: map['id'] as int?,
      correctText: map['correctText'] as String,
      recognizedText: map['recognizedText'] as String,
      cer: map['cer'] as double?,
      mfccSimilarity: map['mfccSimilarity'] as double?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      recognizedAudioPath: map['recognizedAudioPath'] as String?,
    );
  }

  @override
  String toString() {
    return 'PracticeResult{id: $id, correctText: $correctText, recognizedText: $recognizedText, cer: $cer, mfccSimilarity: $mfccSimilarity, timestamp: $timestamp, recognizedAudioPath: $recognizedAudioPath}';
  }
}