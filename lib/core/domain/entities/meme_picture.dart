import 'package:equatable/equatable.dart';

class MemePicture extends Equatable {
  final String id;
  final String name;
  final String url;
  final int width;
  final int height;
  final int boxCount;
  final int captions;

  const MemePicture({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  factory MemePicture.fromJson(Map<String, dynamic> json) {
    return MemePicture(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      boxCount: json['box_count'],
      captions: json['captions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'width': width,
      'height': height,
      'box_count': boxCount,
      'captions': captions,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        width,
        height,
        boxCount,
        captions,
      ];
}
