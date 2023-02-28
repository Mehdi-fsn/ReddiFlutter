import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/constants/reddit_info.dart';
import 'package:redditech/utils/extract_url.dart';
import 'package:redditech/utils/format_number.dart';

class RedditUserPost extends StatelessWidget {
  const RedditUserPost(
      {Key? key,
      required this.subreddit,
      required this.author,
      required this.title,
      required this.selfText,
      required this.thumbnail,
      required this.score,
      required this.numComments,
      required this.createdUtc})
      : super(key: key);

  final String subreddit;
  final String author;
  final String title;
  final String selfText;
  final String thumbnail;
  final int score;
  final int numComments;
  final String createdUtc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            AppTheme.boxShadow,
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  thumbnail,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.network(RedditInfo.urlRedditCharacter),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subreddit,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'posted-by-ago'.i18n([author, createdUtc]),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SelfText(
                        selfText: selfText,
                        score: score,
                        numComments: numComments),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelfText extends StatefulWidget {
  const SelfText(
      {Key? key,
      required this.selfText,
      required this.score,
      required this.numComments})
      : super(key: key);

  final String selfText;
  final int score;
  final int numComments;

  @override
  State<SelfText> createState() => _SelfTextState();
}

class _SelfTextState extends State<SelfText> {
  bool _isExpanded = false;
  bool _isMoreThan100 = false;
  List<String?> _urls = [];
  String _text = "";

  @override
  void initState() {
    super.initState();

    var extracted =
        ExtractUrl.extractUrl(widget.selfText.replaceAll("amp;", ""));
    _urls = extracted['urls'];
    _text = extracted['text'];

    if (_text.length > 100) {
      _isMoreThan100 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isMoreThan100
              ? _isExpanded
                  ? _text
                  : '${_text.substring(0, 100)}...'
              : _text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        if (_urls.isNotEmpty)
          for (var url in _urls)
            ClipRect(
              child: Image.network(
                url!,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
        if (!_isMoreThan100) const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  size: 13,
                  color: Colors.grey.shade600,
                ),
                Icon(
                  Icons.arrow_downward,
                  size: 13,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 5),
                Text(
                  FormatNumber.formatNumber(widget.score),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.comment,
                  size: 13,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.numComments} ${'comments'.i18n()} ${widget.numComments > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            if (_isMoreThan100)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'show-less'.i18n() : 'show-more'.i18n(),
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        if (!_isMoreThan100) const SizedBox(height: 7),
      ],
    );
  }
}
