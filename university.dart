class University {
  String _name;
  String _city;
  int? _ranking;

  University({
    required String name,
    required String city,
    int? ranking,
  })  : _name = name,
        _city = city,
        _ranking = ranking;

  String get name => _name;

  String get city => _city;

  int? get ranking => _ranking;
}

