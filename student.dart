import 'person.dart';

class Student extends Person {
  int batch;
  int level;
  String _secretKey;

  Student(
    String name,
    String cityOfOrigin,
    int age,
    int height,
    this.batch,
    this.level, [
    String secretKey = '01',
  ])  : _secretKey = secretKey,
        super(name, cityOfOrigin, age, height);

  String get secretKey => _secretKey;
}
