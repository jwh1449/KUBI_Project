import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:personal_test/localization/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'announcements_details.dart';


class Announcement {
  final int noticeId;
  final String campus;
  final String title;
  final String link;
  final String author;
  final String date;
  final String content;
  final String contentEn;
  final String contentZh;
  final String titleEn;
  final String titleZh;

  Announcement({
    required this.noticeId,
    required this.campus,
    required this.title,
    required this.link,
    required this.author,
    required this.date,
    required this.content,
    required this.contentEn,
    required this.contentZh,
    required this.titleEn,
    required this.titleZh,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      noticeId: json['noticeId'] ?? 0,
      campus: json['campus'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      author: json['author'] ?? '',
      date: json['date'] ?? '',
      content: json['content'] ?? '',
      contentEn: json['contentEn'] ?? json['content'] ?? '',
      contentZh: json['contentZh'] ?? json['content'] ?? '',
      titleEn: json['titleEn'] ?? json['title'] ?? '',
      titleZh: json['titleZh'] ?? json['title'] ?? '',
    );
  }
}

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({
    super.key,
  });

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  List<Announcement> announcements = [];
  String searchQuery = "";
  bool isLoading = true;
  bool hasError = false;
  String selectedCategory = 'all';

  int _displayCount = 5;
  final int _loadMoreStep = 5;

  final List<String> categoryKeys = ['all', 'samcheok_dogye', 'covid_response'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 언어 변경 시 공지사항을 다시 가져오기 위해 호출합니다.
    fetchAnnouncements();
  }

  void _loadMoreAnnouncements() {
    setState(() {
      _displayCount += _loadMoreStep;
      if (_displayCount > filteredAnnouncements.length) {
        _displayCount = filteredAnnouncements.length;
      }
    });
  }

  Future<void> fetchAnnouncements() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
      _displayCount = _loadMoreStep;
    });

    try {
      final appLanguageProvider = Provider.of<AppLanguageProvider>(context, listen: false);
      final currentLanguageCode = appLanguageProvider.appLocale.languageCode;

      final response = await http.get(
        Uri.parse('https://joljak-backend-production.up.railway.app/api/notices'),
        headers: {
          'Accept-Language': currentLanguageCode,
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final dynamic data = jsonDecode(decodedBody);

        if (!mounted) return;

        if (data is List) {
          setState(() {
            announcements = List<Announcement>.from(
              data.map((item) => Announcement.fromJson(item as Map<String, dynamic>)),
            );
          });
        } else if (data is Map) {
          if (data.containsKey('data') && data['data'] is List) {
            setState(() {
              announcements = List<Announcement>.from(
                (data['data'] as List).map((item) => Announcement.fromJson(item as Map<String, dynamic>)),
              );
            });
          } else {
            setState(() {
              announcements = [Announcement.fromJson(data as Map<String, dynamic>)];
            });
          }
        } else {
          setState(() {
            hasError = true;
          });
          if (mounted) {
            final localizations = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.translate('failedToLoadAnnouncements', {'errorMessage': 'Unexpected data format'}))),
            );
          }
        }
      } else {
        setState(() {
          hasError = true;
        });
        if (mounted) {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.translate('failedToLoadAnnouncements', {'errorMessage': 'HTTP ${response.statusCode}'}))),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
      });
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.translate('networkError'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Announcement> get filteredAnnouncements {
    return announcements.where((announcement) {
      final bool matchesSearch = announcement.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          announcement.titleEn.toLowerCase().contains(searchQuery.toLowerCase()) ||
          announcement.titleZh.toLowerCase().contains(searchQuery.toLowerCase());

      if (selectedCategory == 'all') {
        return matchesSearch;
      } else if (selectedCategory == 'samcheok_dogye') {
        return announcement.campus == '삼척·도계' && matchesSearch;
      } else if (selectedCategory == 'covid_response') {
        return (announcement.title.toLowerCase().contains('코로나19대응') || announcement.title.toLowerCase().contains('코로나') ||
            announcement.titleEn.toLowerCase().contains('covid-19') || announcement.titleEn.toLowerCase().contains('covid') ||
            announcement.titleZh.toLowerCase().contains('新冠') || announcement.titleZh.toLowerCase().contains('疫情')) &&
            matchesSearch;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appLanguageProvider = Provider.of<AppLanguageProvider>(context);
    final currentLanguageCode = appLanguageProvider.appLocale.languageCode;

    final List<Announcement> currentFilteredAnnouncements = filteredAnnouncements;
    final int displayCount = currentFilteredAnnouncements.length < _displayCount
        ? currentFilteredAnnouncements.length
        : _displayCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('announcements'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                      _displayCount = _loadMoreStep;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: localizations.translate('searchAnnouncements'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],

                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    hintText: localizations.translate('filterByCategory'),
                    prefixIcon: const Icon(Icons.filter_list),
                    filled: true,
                    fillColor: Colors.grey[100],

                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categoryKeys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(localizations.translate(key)),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      _displayCount = _loadMoreStep;
                    });
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : hasError
              ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(localizations.translate('couldNotLoadAnnouncements')),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchAnnouncements,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // 텍스트 색상
                    ),
                    child: Text(localizations.translate('tryAgain')),
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: currentFilteredAnnouncements.isEmpty
                ? Center(child: Text(localizations.translate('noAnnouncementsFound')))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final announcement = currentFilteredAnnouncements[index];
                String displayTitle;
                switch (currentLanguageCode) {
                  case 'en':
                    displayTitle = announcement.titleEn;
                    break;
                  case 'zh':
                    displayTitle = announcement.titleZh;
                    break;
                  case 'ko':
                  default:
                    displayTitle = announcement.title;
                    break;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementDetailScreen(
                          announcement: announcement,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.campaign_outlined, color: Colors.lightBlue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                announcement.campus,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (!isLoading && !hasError && displayCount < currentFilteredAnnouncements.length)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _loadMoreAnnouncements,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,// 텍스트 색상
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(localizations.translate('loadMore')),
              ),
            ),
        ],
      ),
    );
  }
}