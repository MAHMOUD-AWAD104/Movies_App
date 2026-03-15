import 'package:movies_app/features/home/tabs/home/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.year,
    required super.rating,
    required super.runtime,
    required super.genres,
    required super.summary,
    required super.descriptionFull,
    required super.language,
    required super.coverImage,
    required super.backgroundImage,
    required super.smallCoverImage,
    required super.largeCoverImage,
    required super.state,
    required super.torrents,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year']?.toString() ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      runtime: json['runtime']?.toString() ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      summary: json['summary'] ?? '',
      descriptionFull: json['description_full'] ?? '',
      language: json['language'] ?? '',
      coverImage: json['cover_image'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      smallCoverImage: json['small_cover_image'] ?? '',
      largeCoverImage: json['large_cover_image'] ?? '',
      state: json['state'] ?? '',
      torrents: (json['torrents'] as List<dynamic>? ?? [])
          .map((t) => TorrentModel.fromJson(t))
          .toList(),
    );
  }
}

class TorrentModel extends TorrentEntity {
  const TorrentModel({
    required super.url,
    required super.hash,
    required super.quality,
    required super.type,
    required super.seeds,
    required super.peers,
    required super.size,
  });

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'] ?? '',
      hash: json['hash'] ?? '',
      quality: json['quality'] ?? '',
      type: json['type'] ?? '',
      seeds: json['seeds'] ?? 0,
      peers: json['peers'] ?? 0,
      size: json['size'] ?? '',
    );
  }
}
