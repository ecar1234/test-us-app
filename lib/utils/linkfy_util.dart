import 'package:flutter_linkify/flutter_linkify.dart';

class WwwLinkifier extends Linkifier {
  const WwwLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, LinkifyOptions options) {
// 1. 정규식 수정: (https:// 또는 http://)가 있을 수도 있고 없을 수도 있는 패턴으로 변경
    final regex = RegExp(
      r'((https|http):\/\/)?(www\.[\w\-]+\.[a-z]{2,})([\/\w\-\?\=\&\#\.]*)*',
      caseSensitive: false, // 대소문자를 구분하지 않도록 설정
    );

    final List<LinkifyElement> list = [];

    for (final element in elements) {
      if (element is TextElement) {
        final matches = regex.allMatches(element.text);

        if (matches.isEmpty) {
          list.add(element);
          continue;
        }

        int start = 0;
        for (final match in matches) {
          if (match.start != start) {
            list.add(TextElement(element.text.substring(start, match.start)));
          }

// 2. 전체 매칭된 URL 텍스트를 가져옴
          final matchedUrl = match.group(0)!;

          String finalUrl;

// 3. 매칭된 URL이 'http'로 시작하는지 확인
          if (matchedUrl.startsWith('http')) {
// 이미 프로토콜이 있으면 변환 없이 그대로 사용
            finalUrl = matchedUrl;
          } else {
// 프로토콜이 없으면 (www로 시작하면) 'https://'를 붙임
            finalUrl = 'https://$matchedUrl';
          }

// 4. UrlElement에 최종 URL을 추가
          list.add(UrlElement(finalUrl, matchedUrl));

          start = match.end;
        }

        if (start != element.text.length) {
          list.add(TextElement(element.text.substring(start)));
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}
