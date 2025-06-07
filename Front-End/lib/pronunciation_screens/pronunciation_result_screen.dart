import 'package:flutter/material.dart';
import 'package:personal_test/localization/app_localizations.dart';

class PronunciationResultScreen extends StatelessWidget {
  final String recognizedText;
  final String correctText;
  final double? cerValue;
  final double? mfccSimilarityScore;

  const PronunciationResultScreen({
    Key? key,
    required this.recognizedText,
    required this.correctText,
    this.cerValue,
    this.mfccSimilarityScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('pronunciationResultTitle'),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // Keeps content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('originalSentence'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        correctText,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.translate('yourRecognition'),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recognizedText,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('accuracyScores'),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      if (cerValue != null)
                        Text(
                          localizations.translate(
                            'cerCharacterErrorRate',
                            {'cerValue': cerValue!.toStringAsFixed(2)},
                          ),
                          style: const TextStyle(fontSize: 18, color: Colors.lightBlue),
                        ),
                      const SizedBox(height: 10),
                      if (mfccSimilarityScore != null)
                        Text(
                          localizations.translate(
                            'mfcc_Similarity',
                            {'mfccSimilarityScore': mfccSimilarityScore!.toStringAsFixed(2)},
                          ),
                          style: const TextStyle(fontSize: 18, color: Colors.purple),
                        ),
                      if (cerValue == null && mfccSimilarityScore == null)
                        Text(
                          localizations.translate('noScoreInformation'),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20), // Added some space above the button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the practice screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  localizations.translate('practiceAgain'),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20), // Extra space below the button to account for bottom navigation bars if present
            ],
          ),
        ),
      ),
    );
  }
}