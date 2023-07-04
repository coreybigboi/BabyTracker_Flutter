
import 'package:baby_tracker_flutter/Entity/BabyEvent.dart';

class Feed extends BabyEvent{

  String duration;
  String feedType;

  Feed({required super.startDate, required super.startTime, required super.note, required this.duration, required this.feedType});

  Feed.fromJson(Map<String, dynamic> json, String id)
      :
        duration = json['duration'],
        feedType = json['feedType'],
        super.fromJson(json, id);

  Map<String, dynamic> toJson() =>
      {
        'startDate': startDate,
        'startTime': startTime,
        'note' : note,
        'duration' : duration,
        'feedType' : feedType,
        'eventType' : 'feed'
      };

}