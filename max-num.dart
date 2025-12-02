int maxNum(int first, int second, int third) {
  int max = first;
  if (second > max) {
    max = second;
  }
  if (third > max) {
    max = third;
  }
  return max;
}

