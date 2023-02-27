abstract class ExtractUrl {
  static Map<String, dynamic> extractUrl(String text) {
    final regExp = RegExp(
      r'((http|https):\/\/)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
      caseSensitive: false,
      multiLine: false,
    );

    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    List<String?> urls = [];

    for (RegExpMatch match in matches) {
      if(match.group(0).toString().contains("https://preview.redd.it/")) {
        urls.add(match.group(0));
      }
    }

    for (var i = 0; i < urls.length; i++) {
      text = text.replaceAll(urls[i].toString(), '');
    }

    return {
      'urls': urls,
      'text': text,
    };
  }
}
