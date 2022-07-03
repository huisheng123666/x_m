class Movie {
  final String id;
  final String title;
  final String cover;
  final String category;
  final String director;
  final String actor;
  final String area;
  final String language;
  final String showTime;
  final String intro;
  final int type;
  final int clicks;
  final List<String> playUrls;

  Movie(
    this.id,
    this.title,
    this.cover,
    this.category,
    this.director,
    this.actor,
    this.area,
    this.language,
    this.showTime,
    this.intro,
    this.type,
    this.clicks,
    this.playUrls,
  );

  factory Movie.formatJson(Map<String, dynamic> data) {
    List<String> urls = [];

    for (var i = 0; i < data['playUrls'][1].length; i++) {
      urls.add(data['playUrls'][1][i]);
    }
    return Movie(
      data['id'],
      data['title'],
      data['cover'],
      data['category'],
      data['director'],
      data['actor'],
      data['area'],
      data['language'],
      data['showTime'],
      data['intro'],
      data['type'],
      data['clicks'],
      urls,
    );
  }
}
