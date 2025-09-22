

import 'package:flutter_linkify/flutter_linkify.dart';

class PlayStoreLinkifier extends Linkifier {
  const PlayStoreLinkifier();

  @override
  List<LinkifyElement> parse(List<LinkifyElement> elements, options) {
    final regex = RegExp(r'https?:\/\/play\.google\.com\/store\/apps\/details\?id=[^\s]+');
    final List<LinkifyElement> list = [];

    for (final element in elements) {
      if (element is TextElement) {
        int start = 0;
        final matches = regex.allMatches(element.text);

        if (matches.isEmpty) {
          list.add(element);
          continue;
        }

        for (final match in matches) {
          if (match.start > start) {
            list.add(TextElement(element.text.substring(start, match.start)));
          }
          list.add(UrlElement(match.group(0)!));
          start = match.end;
        }

        if (start < element.text.length) {
          list.add(TextElement(element.text.substring(start)));
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}