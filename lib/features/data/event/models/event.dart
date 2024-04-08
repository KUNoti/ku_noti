
import 'package:ku_noti/core/constants/constants.dart';
import 'package:ku_noti/features/domain/event/entities/event.dart';


class EventModel extends EventEntity {
  const EventModel({
    super.id,
    super.title,
    super.latitude,
    super.longitude,
    super.startDateTime,
    super.endDateTime,
    super.price,
    super.image,
    super.imageFile,
    super.creator,
    super.detail,
    super.tag,
    super.locationName,
    super.needRegis,
    super.regisAmount,
    super.regisMax
  });

  factory EventModel.fromJson(Map<String, dynamic> map){
    return EventModel(
      id: parseInt(map['id']),
      title: map['title'],
      latitude: map['latitude'] is num ? map['latitude'] : double.tryParse(map['latitude']),
      longitude: map['longitude'] is num ? map['longitude'] : double.tryParse(map['longitude']),
      startDateTime: map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDateTime:  map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      price: map['price'] is num ? map['price'] : double.tryParse(map['price']),
      image: map['image'],
      creator: parseInt(map['creator']),
      detail: map['detail'],
      locationName: map['location_name'],
      needRegis: map['need_regis'],
      regisAmount: parseInt(map['regis_amount']),
      regisMax: parseInt(map['regis_max']),
      // Assume imageFile and other fields are handled similarly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
      "start_date_time": startDateTime?.toIso8601String(),
      "end_date_time": endDateTime?.toIso8601String(),
      "price": price,
      "creator": creator,
      "detail": detail,
      "location_name": locationName,
      "need_regis": needRegis,
      "image_file": imageFile,
      "image": image,
      "tag": tag,
      "regis_amount": regisAmount,
      "regis_max": regisMax,
    };
  }

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
        id: entity.id,
        title: entity.title,
        latitude: entity.latitude,
        longitude: entity.longitude,
        startDateTime: entity.startDateTime,
        endDateTime: entity.endDateTime,
        price: entity.price,
        image: entity.image,
        creator: entity.creator,
        detail: entity.detail,
        locationName: entity.locationName,
        needRegis: entity.needRegis,
        imageFile: entity.imageFile,
        tag: entity.tag,
        regisAmount: entity.regisAmount,
        regisMax: entity.regisMax
    );
  }
}
int? parseInt(dynamic value) {
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}
