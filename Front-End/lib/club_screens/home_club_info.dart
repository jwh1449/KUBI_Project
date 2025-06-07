import 'dart:convert'; // For jsonDecode and utf8.decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:personal_test/localization/app_localizations.dart'; // Crucial for localization
import 'club_details.dart'; // Import for ClubDetailScreen

// 1. Club Model Class Definition
class Club {
  final int clubId;
  final String clubName;
  final String clubCategory;
  final String clubDescription;
  final String clubDescriptionEn;
  final String clubDescriptionZh;

  Club({
    required this.clubId,
    required this.clubName,
    required this.clubCategory,
    required this.clubDescription,
    required this.clubDescriptionEn,
    required this.clubDescriptionZh,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      clubId: json['clubId'] as int? ?? 0,
      clubName: json['clubName'] as String? ?? 'No Name',
      clubCategory: json['clubCategory'] as String? ?? 'No Category',
      clubDescription: json['clubDescription'] as String? ?? 'No Description',
      clubDescriptionEn: json['clubDescriptionEn'] as String? ?? 'No Description',
      clubDescriptionZh: json['clubDescriptionZh'] as String? ?? '无说明',
    );
  }
}

// 2. ClubInfoScreen StatefulWidget
class ClubInfoScreen extends StatefulWidget {
  const ClubInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ClubInfoScreen> createState() => _ClubInfoScreenState();
}

class _ClubInfoScreenState extends State<ClubInfoScreen> {
  List<Club> clubs = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchClubs();
  }

  Future<void> fetchClubs() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://joljak-backend-production.up.railway.app/api/clubs'),
      );

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(jsonString);

        setState(() {
          clubs = data.map((json) => Club.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        if (mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${localizations.translate('failedToLoadClubInfo')} ${response.statusCode}'),
            ),
          );
        }
        throw Exception('Failed to load club data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('networkError'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue, // lightBlue 유지
        centerTitle: true,
        title: Text(
          localizations.translate('clubInformation'),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(
          // 로딩 인디케이터 색상은 main.dart의 theme를 따름
          child: CircularProgressIndicator(),
        )
            : hasError
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localizations.translate('unableToLoadClubInfo')),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: fetchClubs,
                style: ElevatedButton.styleFrom(
                  // 배경색은 main.dart의 theme를 따름
                  foregroundColor: Colors.white, // 텍스트 색상
                ),
                child: Text(localizations.translate('tryAgain')),
              ),
            ],
          ),
        )
            : clubs.isEmpty
            ? Center(child: Text(localizations.translate('noRegisteredClubInfo')))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('availableClubs'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  final club = clubs[index];
                  return _buildClubCard(club, context, localizations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubCard(Club club, BuildContext context, AppLocalizations localizations) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailScreen(club: club),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  club.clubName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 8),
              Text(
                  _getLocalizedDescription(club, localizations.locale.languageCode, localizations),
                  style: const TextStyle(fontSize: 14, color: Colors.grey)
              ),
              const SizedBox(height: 4),
              Text(
                  '${localizations.translate('category')}: ${club.clubCategory}',
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey)
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedDescription(Club club, String languageCode, AppLocalizations localizations) {
    if (languageCode == 'en' && club.clubDescriptionEn.isNotEmpty && club.clubDescriptionEn != 'No Description') {
      return club.clubDescriptionEn;
    } else if (languageCode == 'zh' && club.clubDescriptionZh.isNotEmpty && club.clubDescriptionZh != '无说明') {
      return club.clubDescriptionZh;
    }
    return club.clubDescription.isNotEmpty && club.clubDescription != 'No Description'
        ? club.clubDescription
        : localizations.translate('noDescription');
  }
}