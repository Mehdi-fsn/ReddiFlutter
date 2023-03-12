class RedditSub {
  final String name;

  RedditSub({required this.name});

  static RedditSub fromJson(Map<String, dynamic> json) => RedditSub(
    name: json["name"],
  );
}