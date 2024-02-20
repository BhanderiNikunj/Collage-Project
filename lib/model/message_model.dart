class MessageModel {
  final String id;
  final String date;
  final String time;
  final String message;
  final bool isMessageSend;

  MessageModel({
    required this.id,
    required this.date,
    required this.time,
    required this.message,
    required this.isMessageSend,
  });
}
