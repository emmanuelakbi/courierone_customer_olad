import 'package:courierone/models/user/media_library.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInformation {
  final int id;
  final String name;
  final String email;
  String image_url;

  @JsonKey(name: 'mobile_number')
  final String mobileNumber;

  @JsonKey(name: 'mobile_verified')
  final int mobileVerified;

  final int active;
  final String language;
  final notification;
  final meta;
  MediaLibrary mediaurls;

  @JsonKey(name: 'remember_token')
  final rememberToken;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  UserInformation({
    this.id,
    this.name,
    this.email,
    this.image_url,
    this.mobileNumber,
    this.mobileVerified,
    this.active,
    this.language,
    this.notification,
    this.meta,
    this.mediaurls,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'UserInformation(id: $id, name: $name, email: $email, image_url: $image_url, mobileNumber: $mobileNumber, mobileVerified: $mobileVerified, active: $active, language: $language, mediaurls: $mediaurls, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserInformation && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  String get imageUrl => mediaurls != null &&
          mediaurls.images != null &&
          mediaurls.images.isNotEmpty
      ? mediaurls.images.first.defaultImage
      : null;

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);

  Map<String, dynamic> toJson() => _$UserInformationToJson(this);
}
