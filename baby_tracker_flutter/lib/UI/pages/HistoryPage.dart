import 'package:baby_tracker_flutter/Entity/BabyEvent.dart';
import 'package:baby_tracker_flutter/Entity/BabyEventChangeNotifier.dart';
import 'package:baby_tracker_flutter/Entity/Feed.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:baby_tracker_flutter/UI/pages/EditFeedPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../Entity/Nappy.dart';
import '../../Entity/Sleep.dart';
import 'EditNappyPage.dart';
import 'EditSleepPage.dart';
import 'SummaryPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  // Event types
  final ALL = "all";
  final FEED = "feed";
  final NAPPY = "nappy";
  final SLEEP = "sleep";

  // State
  String deleteText = "Delete";
  late DateTime dateFilter = DateTime.now();
  late String eventTypeFilter = ALL;

  String formatDate(DateTime date){
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$day-$month-$year';
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: dateFilter,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      if(value == null) return;
      setState(() {
        dateFilter = value;
      });
      setProviderDateFilter(formatDate(dateFilter));
      applyFilters();
    });
  }

  void onDismissed(BabyEvent event){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Are you sure you want to delete this?"),
            content: Image.asset("assets/delete.gif"),
            actions: [
              TextButton(
              onPressed: () { deleteEvent(event); },
              child: Text(deleteText, style: const TextStyle(color: Colors.red, fontSize: 20),),
              ),
              TextButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("Cancel", style: TextStyle(color: Colors.blue, fontSize: 20),),
              ),
            ],
          );
        });
  }

  void setProviderDateFilter(String date){
    Provider.of<BabyEventChangeNotifier>(context, listen: false).dateFilter = date;
  }

  void setProviderTypeFilter(String type){
    Provider.of<BabyEventChangeNotifier>(context, listen: false).typeFilter = type;
  }

  void applyFilters(){
    Provider.of<BabyEventChangeNotifier>(context, listen: false).filterBabyEvents();
  }

  void deleteEvent(BabyEvent event){
    Provider.of<BabyEventChangeNotifier>(context, listen: false).delete(event.id);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<BabyEventChangeNotifier>(context, listen: false).dateFilter = formatDate(DateTime.now());
    Provider.of<BabyEventChangeNotifier>(context, listen: false).typeFilter = ALL;
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BabyEventChangeNotifier>(
      builder: buildCenter
    );
  }

  Center buildCenter(BuildContext context, BabyEventChangeNotifier babyEventChangeNotifier, _) {
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                onPressed: _showDatePicker,
                label: Text(formatDate(dateFilter), style: const TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                icon: const Icon(Icons.calendar_month_rounded, color: Colors.white)
            ),
            DropdownButton<String>(
              value: eventTypeFilter,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  eventTypeFilter = newValue!;
                });
                setProviderTypeFilter(eventTypeFilter);
                applyFilters();
              },
              items: [
                DropdownMenuItem(value: ALL, child: const Text("All 🌞")),
                DropdownMenuItem(value: FEED, child: const Text("Feeds 🤱")),
                DropdownMenuItem(value: NAPPY, child: const Text("Nappies 🚼")),
                DropdownMenuItem(value: SLEEP, child: const Text("Sleeps 😴"))
              ],
            ),
          ],
        ),
        if (babyEventChangeNotifier.loading) const Padding(
          padding: EdgeInsets.symmetric(vertical: 276.0),
          child: CircularProgressIndicator(),
        ) else Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                BabyEvent event = babyEventChangeNotifier.filteredItems[index];
                return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white,),
                    ),
                    confirmDismiss: (direction) async{
                        onDismissed(event);
                        return false;
                      },
                    key: ValueKey(event.id),
                    child: createListItem(event),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                indent: 20,
                endIndent: 20,
              ),
              itemCount: babyEventChangeNotifier.filteredItems.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    String summary = Provider.of<BabyEventChangeNotifier>(context, listen: false).generateSummary();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SummaryPage(date: formatDate(dateFilter), summary: summary);
                        }));
                  },
                  icon: const Icon(Icons.event_note_rounded, color: Colors.white),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  label: Text("Summary for ${formatDate(dateFilter)}", style: const TextStyle(color: Colors.white),),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    final String shareText = Provider.of<BabyEventChangeNotifier>(context, listen: false).generateShareText();
                    await Share.share(shareText);
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  label: const Text("Share", style: TextStyle(color: Colors.white),)
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }

  ListTile createListItem(BabyEvent event){

    // Case 1: feed
    if(event is Feed){
      // create duration string
      List<String> durationValues = event.duration.split(",");
      String duration = "${durationValues[0]}h ${durationValues[1]}m ${durationValues[2]}s";

      return ListTile(
          title: Row(
            children: [
              const HighlightedText(label: "Feed", colour: Colors.red),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('${event.startTime} ($duration)', style: const TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
          subtitle: Text(event.feedType),
          leading: const Icon(Icons.water_drop, color: Colors.red,),
          trailing: Text(event.note),
        onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EditFeedPage(id: event.id);
                }));
        },
      );
    }

    // Case 2: nappy
    if(event is Nappy){
      return ListTile(
        title: Row(
          children: [
            const HighlightedText(label: "Nappy", colour: Colors.blue),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(event.startTime, style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
        subtitle: Text(event.nappyType),
        leading: const Icon(Icons.baby_changing_station, color: Colors.blue,),
        trailing: Text(event.note),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EditNappyPage(id: event.id);
              }));
        },
      );
    }

    // Case 3: sleep
    if(event is Sleep) {
      List<String> durationValues = event.duration.split(",");
      String duration = "${durationValues[0]}h ${durationValues[1]}m ${durationValues[2]}s";
      return ListTile(
        title: Row(
          children: [
            const HighlightedText(label: "Sleep", colour: Colors.purpleAccent),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('${event.startTime} ($duration)', style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
        leading: const Icon(Icons.bedroom_baby, color: Colors.purpleAccent,),
        trailing: Text(event.note),
        onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return EditSleepPage(id: event.id);
            }));
      },
      );
    }

    return const ListTile();
  }
}
