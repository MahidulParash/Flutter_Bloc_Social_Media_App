// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
      ];

  @override
  String toString() {
    return '''UserEntity: {
      id: $id
      email: $email
      name: $name
    }''';
  }
}
