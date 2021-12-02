import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/doctor.dart';
import 'package:givememedicineapp/entity/medicine.dart';

@Entity(foreignKeys: [
  ForeignKey(entity: Doctor, childColumns: ['doctorId'], parentColumns: ['id']),
])
class Sales {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final int salesRepresentativeId;
  final int doctorId;
  final String remark;
  final String date;
  bool tagged;

  Sales(
      {this.id,
      required this.salesRepresentativeId,
      required this.doctorId,
      required this.remark,
      required this.date,
      required this.tagged});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_representative'] = salesRepresentativeId;
    data['doctor'] = doctorId;
    data['remark'] = remark;
    data['date'] = date;
    data['tagged'] = tagged;
    return data;
  }
}

@Entity(foreignKeys: [
  ForeignKey(entity: Sales, childColumns: ['salesId'], parentColumns: ['id']),
  ForeignKey(
      entity: Medicine, childColumns: ['medicineId'], parentColumns: ['id'])
])
class SalesMedicine {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? salesId;
  final int medicineId;
  final String quantityType;
  final int quantity;
  bool tagged;

  SalesMedicine(
      {required this.id,
      this.salesId,
      required this.medicineId,
      required this.quantityType,
      required this.quantity,
      required this.tagged});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_representative'] = salesId;
    data['doctor'] = medicineId;
    data['remark'] = quantityType;
    data['date'] = quantity;
    return data;
  }
}
