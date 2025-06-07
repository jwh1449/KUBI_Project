import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:personal_test/transport/app_language_provider.dart';
import 'package:personal_test/announcement_screen/home_announcements.dart'; // Announcement 모델 임포트

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({
    required this.announcement,
    super.key,
  });

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  // 선택된 언어에 따라 공지 내용을 반환하는 헬퍼 함수
  String _getLocalizedContent(Announcement ann, MenuLanguage currentLanguage) {
    switch (currentLanguage) {
      case MenuLanguage.korean:
        return ann.content.isNotEmpty ? ann.content : '내용 없음';
      case MenuLanguage.english:
        return ann.contentEn.isNotEmpty ? ann.contentEn : 'No English content available.';
      case MenuLanguage.chinese:
        return ann.contentZh.isNotEmpty ? ann.contentZh : '无中文内容。';
    }
  }

  // 선택된 언어에 따라 공지 제목을 반환하는 헬퍼 함수
  String _getLocalizedAnnouncementTitle(Announcement ann, MenuLanguage currentLanguage) {
    switch (currentLanguage) {
      case MenuLanguage.korean:
        return ann.title.isNotEmpty ? ann.title : '제목 없음';
      case MenuLanguage.english:
        return ann.titleEn.isNotEmpty ? ann.titleEn : 'No English title available.';
      case MenuLanguage.chinese:
        return ann.titleZh.isNotEmpty ? ann.titleZh : '无中文标题。';
    }
  }

  // 언어별 UI 텍스트를 반환하는 헬퍼 함수
  String _getLocalizedUIText(String type, MenuLanguage currentLanguage) {
    switch (currentLanguage) {
      case MenuLanguage.korean:
        if (type == 'appBar') return '공지사항 상세';
        if (type == 'campus') return '[캠퍼스]';
        if (type == 'noticeId') return '공지 ID:';
        if (type == 'link') return '자세한 정보 (링크)';
        if (type == 'author') return '작성자:';
        if (type == 'date') return '날짜:';
        return '';
      case MenuLanguage.english:
        if (type == 'appBar') return 'Announcement Details';
        if (type == 'campus') return '[Campus]';
        if (type == 'noticeId') return 'Notice ID:';
        if (type == 'link') return 'More Info (Link)';
        if (type == 'author') return 'Author:';
        if (type == 'date') return 'Date:';
        return '';
      case MenuLanguage.chinese:
        if (type == 'appBar') return '公告详情';
        if (type == 'campus') return '[校区]';
        if (type == 'noticeId') return '公告 ID:';
        if (type == 'link') return '更多信息 (链接)';
        if (type == 'author') return 'Author:';
        if (type == 'date') return 'Date:';
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLanguageProvider = Provider.of<AppLanguageProvider>(context);
    final currentLanguage = appLanguageProvider.currentMenuLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getLocalizedUIText('appBar', currentLanguage),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // 공지 제목 (번역된 제목 사용)
            Text(
              _getLocalizedAnnouncementTitle(widget.announcement, currentLanguage),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // 캠퍼스 정보
            Text(
              '${_getLocalizedUIText('campus', currentLanguage)}\n${widget.announcement.campus}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            // noticeId 정보 추가
            if (widget.announcement.noticeId != 0)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${_getLocalizedUIText('noticeId', currentLanguage)} ${widget.announcement.noticeId}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            // 선택된 언어의 공지 내용만 표시
            Text(
              _getLocalizedContent(widget.announcement, currentLanguage),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // "link" 필드 추가 및 클릭 기능
            if (widget.announcement.link.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () async {
                    String rawLink = widget.announcement.link;
                    if (!rawLink.startsWith('http://') && !rawLink.startsWith('https://')) {
                      rawLink = 'https://$rawLink';
                    }

                    final Uri url = Uri.parse(rawLink);

                    try {
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('링크를 열 수 없습니다: $url')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('링크를 여는 중 오류가 발생했습니다: $e')),
                        );
                      }
                    }
                  },
                  child: Text(
                    _getLocalizedUIText('link', currentLanguage),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            // 작성자 및 날짜 추가
            if (widget.announcement.author.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${_getLocalizedUIText('author', currentLanguage)} ${widget.announcement.author}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            if (widget.announcement.date.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${_getLocalizedUIText('date', currentLanguage)} ${widget.announcement.date}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}