int optionalSum(int first, int second, [int? third]) {
  return first + second + (third ?? 0);
}

