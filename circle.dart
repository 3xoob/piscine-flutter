class Circle {
  double x;
  double y;
  double radius;

  Circle({
    required this.x,
    required this.y,
    required this.radius,
  });

  double get area => 3.14 * radius * radius;

  double get perimeter => 2 * 3.14 * radius;

  double get rightMostCoordinate => x + radius;

  double get leftMostCoordinate => x - radius;

  double get highestCoordinate => y + radius;

  double get lowestCoordinate => y - radius;
}

