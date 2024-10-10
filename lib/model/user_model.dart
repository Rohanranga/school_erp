import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? enrollmentNumber;

  @HiveField(2)
  String? academicYear;

  @HiveField(3)
  String? branch;

  @HiveField(4)
  String? dateOfBirth;

  @HiveField(5)
  String? contactNumber;

  @HiveField(6)
  String? motherName;

  @HiveField(7)
  String? fatherName;

  @HiveField(8)
  String? address;

  @HiveField(9)
  String? semester;

  @HiveField(10)
  String? email;

  UserModel(
    this.name,
    this.enrollmentNumber,
    this.academicYear,
    this.branch,
    this.dateOfBirth,
    this.contactNumber,
    this.motherName,
    this.fatherName,
    this.address,
    this.semester,
    this.email,
  );

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    enrollmentNumber = json['enrollment'];
    academicYear = json['academic_year'];
    branch = json['branch'];
    dateOfBirth = json['dob'];
    contactNumber = json['contact_number'];
    motherName = json['mother_name'];
    fatherName = json['father_name'];
    address = json['address'];
    semester = json['semester'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? "";
    data['enrollment'] = enrollmentNumber ?? "";
    data['academic_year'] = academicYear ?? "";
    data['branch'] = branch ?? "";
    data['dob'] = dateOfBirth ?? "";
    data['contact_number'] = contactNumber ?? "";
    data['mother_name'] = motherName ?? "";
    data['father_name'] = fatherName ?? "";
    data['address'] = address ?? "";
    data['semester'] = semester ?? "";
    data['email'] = email ?? "";
    return data;
  }
}
