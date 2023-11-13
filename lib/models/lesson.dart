class Lesson {
  String title;
  int num;
  String teacherName;
  String cab;

  Lesson({required this.title, required this.num, required this.teacherName, required this.cab});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'] ?? '',
      num: int.parse(json['num'] ?? '0'),
      teacherName: json['teachername'] ?? '',
      cab: json['cab'] ?? '',
    );
  }
}
