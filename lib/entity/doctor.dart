import 'package:floor/floor.dart';

@entity
class Doctor {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int syncedId;
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final String nameOfTheClinic;

  Doctor(this.syncedId, this.firstName, this.lastName, this.address, this.phone,
      this.nameOfTheClinic);

  Doctor.fromJson(Map json)
      : syncedId = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        address = json['address'],
        phone = json['phone'],
        nameOfTheClinic = json['name_of_the_clinic'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['synced_id'] = syncedId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['address'] = address;
    data['phone'] = phone;
    data['name_of_the_clinic'] = nameOfTheClinic;
    return data;
  }
}
