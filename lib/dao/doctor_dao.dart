import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/doctor.dart';

@dao
abstract class DoctorDao {
  @Query('SELECT * FROM Doctor')
  Future<List<Doctor>> findAllDoctor();

  @Query('SELECT * FROM Doctor WHERE id = :id')
  Stream<Doctor?> findDoctorById(int id);

  @insert
  Future<int> insertDoctor(Doctor doctor);

  @insert
  Future<List<int>> insertDoctors(List<Doctor> doctors);
}
