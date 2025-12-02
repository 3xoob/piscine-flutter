class Person {
  String name;
  String? surname;
  String cityOfOrigin;
  int age;
  int height;

  Person(
    this.name,
    this.cityOfOrigin,
    this.age,
    this.height, [
    this.surname,
  ]);
}
