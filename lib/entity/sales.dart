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
  final int tagged;

  Sales(this.salesRepresentativeId, this.doctorId, this.remark, this.date,
      this.tagged);

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
  final int salesId;
  final int medicineId;
  final String quantityType;
  final int quantity;

  SalesMedicine(
      this.salesId, this.medicineId, this.quantityType, this.quantity);
}
