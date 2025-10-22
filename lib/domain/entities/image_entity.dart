

import '../../data/models/image/image_model.dart';

class ImageEntity {
  int? id;
  String? filename;
  String? originalname;
  String? mimetype;
  int? size;
  String? url;
  DateTime? createdAt;
  ImageEntity({this.id, this.filename, this.originalname, this.mimetype, this.size, this.url, this.createdAt});

  static ImageEntity toImageEntity (ImageModel model){
    return ImageEntity(
      id: model.id,
      filename: model.filename,
      originalname: model.originalname,
      mimetype: model.mimetype,
      size: model.size,
      url: model.url,
      createdAt: model.createdAt
    );
  }
  static ImageModel toImageModel (ImageEntity entity) {
    return ImageModel(
      id: entity.id,
      filename: entity.filename,
      originalname: entity.originalname,
      mimetype: entity.mimetype,
      size: entity.size,
      url: entity.url,
      createdAt: entity.createdAt
    );
  }
}