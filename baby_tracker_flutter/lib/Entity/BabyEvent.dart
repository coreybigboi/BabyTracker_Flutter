
class BabyEvent{
  late String id;
  String startDate;
  String startTime;
  String note;

  BabyEvent({ required this.startDate, required this.startTime, required this.note });

  BabyEvent.fromJson(Map<String, dynamic> json, this.id)
      :
        startDate = json['startDate'],
        startTime = json['startTime'],
        note = json['note'];

  Map<String, dynamic> toJson() =>
      {
        'startDate': startDate,
        'startTime': startTime,
        'note' : note
      };
}