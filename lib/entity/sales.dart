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

  Sales.fromJson(Map json)
      : salesRepresentativeId = json['sales_representative'],
        doctorId = json['doctor'],
        remark = json['remark'],
        date = json['date'],
        tagged = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_representative'] = salesRepresentativeId.toString();
    data['doctor'] = doctorId.toString();
    data['remark'] = remark;
    data['date'] = date;
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

  SalesMedicine.fromJson(Map json)
      : salesId = json['sales_action'],
        medicineId = json['medicine'],
        quantityType = json['quantity_type'],
        quantity = json['quantity'],
        tagged = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sales_representative'] = salesId;
    data['doctor'] = medicineId;
    data['remark'] = quantityType;
    data['date'] = quantity;
    return data;
  }
}
