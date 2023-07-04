import 'package:baby_tracker_flutter/Entity/BabyEvent.dart';
import 'package:baby_tracker_flutter/Entity/Feed.dart';
import 'package:baby_tracker_flutter/Entity/Nappy.dart';
import 'package:baby_tracker_flutter/Entity/Sleep.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BabyEventChangeNotifier extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<BabyEvent> items = [];
  final List<BabyEvent> filteredItems = [];

  // Event types
  final ALL = "all";
  final FEED = "feed";
  final NAPPY = "nappy";
  final SLEEP = "sleep";

  // Firebase collection
  final CollectionReference babyEventCollection = FirebaseFirestore.instance.collection("babyEvents");

  // State
  bool loading = false;
  bool isFetching = false;
  String dateFilter = "";
  String typeFilter = "";

  BabyEventChangeNotifier() {
    fetch();
  }

  BabyEvent? convertDocToBabyEvent(DocumentSnapshot doc){
    final data = doc.data()! as Map<String, dynamic>;

    if(data['eventType'].toString() == FEED){
      var feed = Feed.fromJson(data, doc.id);
      return feed;
    }
    if(data['eventType'].toString() == NAPPY){
      var nappy = Nappy.fromJson(data, doc.id);
      return nappy;
    }
    if(data['eventType'].toString() == SLEEP){
      var sleep = Sleep.fromJson(data, doc.id);
      return sleep;
    }

    return null;
  }

  Future fetch() async
  {
    loading = true;
    isFetching = true;

    notifyListeners();

    // get all baby events
    var querySnapshot = await babyEventCollection.orderBy("startTime").get();

    //clear any existing data we have gotten previously, to avoid duplicate data
    items.clear();

    for (var doc in querySnapshot.docs) {
      final BabyEvent? event = convertDocToBabyEvent(doc);
      if(event != null) items.add(event);
    }

    items.sort((a, b) => b.startTime.compareTo(a.startTime));

    loading = false;
    isFetching = false;
    update();
  }

  Future add(BabyEvent item, Function callback) async {
    loading = true;
    update();

    await babyEventCollection.add(item.toJson());
    callback();
    await fetch();
  }

  Future updateBabyEvent(String id, BabyEvent event, Function callback) async {
    loading = true;
    update();

    await babyEventCollection.doc(id).set(event.toJson());
    await fetch();
    await filterBabyEvents();
    callback();
  }

  Future delete(String id) async
  {
    loading = true;
    update();

    await babyEventCollection.doc(id).delete();
    await fetch();
    await filterBabyEvents();

    loading = false;
    update();
  }

  BabyEvent? get(String? id)
  {
    if (id == null) return null;
    return items.firstWhere((event) => event.id == id);
  }

  Future filterBabyEvents() async{

    loading = true;
    update();

    filteredItems.clear();

    // wait if still fetching
    while (isFetching) {
      await Future.delayed(const Duration(milliseconds: 100)); // Adjust the duration as needed
    }

    for(int i = 0; i < items.length; i++){
      BabyEvent event = items[i];

      if(event.startDate != dateFilter) continue;

      if(typeFilter == ALL ){
        filteredItems.add(event);
      }

      if(typeFilter == FEED){
        if(event is Feed) filteredItems.add(event);
      }

      if(typeFilter == NAPPY){
        if(event is Nappy) filteredItems.add(event);
      }

      if(typeFilter == SLEEP){
        if(event is Sleep) filteredItems.add(event);
      }
    }

    loading = false;
    update();
  }

  String generateSummary(){
    String summary = "";

    int totalFeeds = 0;
    int totalNappies = 0;
    int totalSleeps = 0;

    for(int i = 0; i < filteredItems.length; i++){
      BabyEvent event = filteredItems[i];
      if(event is Feed){
        totalFeeds++;
      }
      if(event is Nappy){
        totalNappies++;
      }
      if(event is Sleep){
        totalSleeps++;
      }
    }

    summary = """
    Total Feeds: $totalFeeds
    
    Total Nappies: $totalNappies
    
    Total Sleeps: $totalSleeps
    """;

    return summary;
  }

  String generateShareText(){
    String shareText = "Summary for $dateFilter:\n";

    for(int i = 0; i < filteredItems.length; i++){
      BabyEvent event = filteredItems[i];
      if(event is Feed){
        shareText += """
        
        Feed
        Start Time: ${event.startTime}
        Duration (h,m,s): ${event.duration}
        Feed type: ${event.feedType}
        Note: ${event.note}
        """;
      }
      if(event is Nappy){
        shareText += """
        
        Nappy
        Start Time: ${event.startTime}
        Nappy type: ${event.nappyType}
        Note: ${event.note}
        """;
      }
      if(event is Sleep){
        shareText += """
        
        Sleep
        Start Time: ${event.startTime}
        Duration (h,m,s): ${event.duration}
        Note: ${event.note}
        """;
      }
    }

    return shareText;
  }

  //update any listeners
  // This call tells the widgets that are listening to this model to rebuild.
  void update() { notifyListeners(); }
}