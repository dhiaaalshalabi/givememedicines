import 'package:floor/floor.dart';
import 'package:givememedicineapp/entity/sales.dart';

@dao
abstract class SalesDao {
  @Query('SELECT * FROM Sales')
  Future<List<Sales>> findAllSales();

  @Query('SELECT * FROM Sales WHERE id = :id')
  Stream<Sales?> findSalesById(int id);

  @insert
  Future<int> insertSales(Sales sales);
}
