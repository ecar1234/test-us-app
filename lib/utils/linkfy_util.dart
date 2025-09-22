

import 'package:flutter_linkify/flutter_linkify.dart';

class WwwLinkifier extends Linkifier {
  const WwwLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, options) {
    final regex = RegExp(r'(www\.[\w\-]+\.[a-z]{2,})([\/\w\-\?\=\&\#\.]*)*');
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

          final url = match.group(0)!;
          final normalized = 'https://$url'; // 프로토콜 붙이기
          list.add(UrlElement(normalized));

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