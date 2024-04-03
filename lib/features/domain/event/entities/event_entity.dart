
import 'dart:io';

import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String ? title;
  final num ? latitude;
  final num ? longitude;
  final DateTime ? startDateTime;
  final DateTime ? endDateTime;
  final num ? price;
  final String ? image;
  final File ? imageFile;
  final int ? creator;
  final String ? detail;
  final String ? tag;
  final String ? locationName;
  final bool ? needRegis;

  const EventEntity({
    this.title,
    this.latitude,
    this.longitude,
    this.startDateTime,
    this.endDateTime,
    this.price,
    this.image,
    this.imageFile,
    this.creator,
    this.detail,
    this.tag,
    this.locationName,
    this.needRegis
  });

  @override
  List<Object ?> get props {
    return [
      title,
      latitude,
      longitude,
      startDateTime,
      endDateTime,
      price,
      image,
      imageFile,
      creator,
      detail,
      tag,
      locationName,
      needRegis,
    ];
  }
}