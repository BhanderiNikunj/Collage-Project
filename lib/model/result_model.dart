class ResultModel {
  final String id;
  final String name;
  final String uid;
  final String mathMark;
  final String scienceMark;
  final String englishMark;
  final String ssMark;
  final String totalMark;
  final String totalSingleSubjectMark;
  final String totalOutOfMark;
  final String month;

  ResultModel({
    required this.id,
    required this.name,
    required this.uid,
    required this.mathMark,
    required this.scienceMark,
    required this.englishMark,
    required this.ssMark,
    required this.totalMark,
    required this.totalOutOfMark,
    required this.month,
    required this.totalSingleSubjectMark,
  });
}

List<String> listOfSubject = [
  "Subject",
  "Math's",
  "Science",
  "Englist",
  "S.S.",
];
