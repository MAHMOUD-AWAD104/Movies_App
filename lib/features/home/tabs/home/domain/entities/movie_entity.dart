import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id;
  final String title;
  final String year;
  final double rating;
  final String runtime;
  final List<String> genres;
  final String summary;
  final String descriptionFull;
  final String language;
  final String coverImage;
  final String backgroundImage;
  final String smallCoverImage;
  final String largeCoverImage;
  final String state;
  final List<TorrentEntity> torrents;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.genres,
    required this.summary,
    required this.descriptionFull,
    required this.language,
    required this.coverImage,
    required this.backgroundImage,
    required this.smallCoverImage,
    required this.largeCoverImage,
    required this.state,
    required this.torrents,
  });

  @override
  List<Object?> get props => [id, title, year, rating];
}

class TorrentEntity extends Equatable {
  final String url;
  final String hash;
  final String quality;
  final String type;
  final int seeds;
  final int peers;
  final String size;

  const TorrentEntity({
    required this.url,
    required this.hash,
    required this.quality,
    required this.type,
    required this.seeds,
    required this.peers,
    required this.size,
  });

  @override
  List<Object?> get props => [url, quality];
}
