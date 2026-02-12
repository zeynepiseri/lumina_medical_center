import '../../domain/entities/specialty_entity.dart';

class SpecialtyModel extends SpecialtyEntity {
  const SpecialtyModel({required super.id, required super.name});

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  SpecialtyEntity toEntity() => SpecialtyEntity(id: id, name: name);
}
