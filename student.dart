import 'person.dart';

class Student extends Person {
  int batch;
  int level;
  String _secretKey;

  Student({
    required String name,
    required String cityOfOrigin,
    required int age,
    required int height,
    required this.batch,
    required this.level,
    String secretKey = '01',
  })  : _secretKey = secretKey,
        super(
          name: name,
          cityOfOrigin: cityOfOrigin,
          age: age,
          height: height,
        );

  String get secretKey => _secretKey;
}
