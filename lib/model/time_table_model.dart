class TimeTableModel {
  final String id;
  final String startingTime;
  final String endingTime;
  final String sirName;
  final String subjectName;
  final String periodName;
  final String weekName;
  final String std;

  TimeTableModel({
    required this.id,
    required this.startingTime,
    required this.endingTime,
    required this.sirName,
    required this.subjectName,
    required this.periodName,
    required this.weekName,
    required this.std,
  });
}
