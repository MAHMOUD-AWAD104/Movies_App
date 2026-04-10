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
    required super.likerCount,
    required super.screenShot1,
    required super.screenShot2,
    required super.screenShot3,
    required super.casting,
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
      likerCount: (json['like_count'] ?? 0).toInt(),
      coverImage: json['cover_image'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      smallCoverImage: json['small_cover_image'] ?? '',
      largeCoverImage: json['large_cover_image'] ?? '',
      state: json['state'] ?? '',
      torrents: (json['torrents'] as List<dynamic>? ?? [])
          .map((t) => TorrentModel.fromJson(t))
          .toList(),
      screenShot1: json['large_screenshot_image1'] ?? '',
      screenShot2: json['large_screenshot_image2'] ?? '',
      screenShot3: json['large_screenshot_image3'] ?? '',
      casting: (json['cast'] as List<dynamic>? ?? [])
          .map((t) => CastModel.fromJson(t))
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

class CastModel extends CastEntity {
  const CastModel({
    required super.name,
    required super.characterName,
    required super.urlImage,
    required super.imdbCode,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      characterName: json['character_name'] ?? '',
      urlImage: json['url_small_image'] ?? '',
      imdbCode: json['imdb_code'] ?? '',
    );
  }
}
