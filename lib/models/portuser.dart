import 'package:flutter/foundation.dart';
import 'company.dart';

class Portuser {
  final String uuid;
  final String name;
  final Company company;
  final String expiresOn;
  final Photo photo;
  final int active;

  Portuser({
    @required this.uuid,
    @required this.name,
    this.company,
    this.expiresOn,
    this.photo,
    this.active
  });

  factory Portuser.fromJson(Map<String, dynamic> parsedJson){

    int isActive = 0;

    if (parsedJson['active'] != null) {
      isActive = 1;
    }

    return Portuser(
        uuid: parsedJson['uuid'],
        name: parsedJson['name'],
        company: Company.fromJson(parsedJson['company']),
      expiresOn: parsedJson['expires_on'],
      photo: Photo.fromJson(parsedJson['media'][0]),
      active: isActive
    );
  }
}

class Photo {
  final String url;
  final String urlThumb;

  Photo({
    this.url,
    this.urlThumb
  });

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
        url: json['url'],
        urlThumb: json['url_thumb']
    );
  }
}

class Active {

}