import 'package:baby_tracker_flutter/Entity/Profile.dart';
import 'package:baby_tracker_flutter/Entity/ProfileChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:baby_tracker_flutter/UI/pages/EditProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void goToEditProfilePage(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EditProfilePage(profile: Provider.of<ProfileChangeNotifier>(context, listen: false).profile)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
        builder: buildHomePage
    );
  }

  Widget buildHomePage(BuildContext context, ProfileChangeNotifier profileChangeNotifier, _) {
    if (profileChangeNotifier.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Baby\nTracker", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            Image.asset('assets/home.gif',
              width: 200,
              height: 400,
              fit: BoxFit.contain,
            )
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HighlightedText(label: "${profileChangeNotifier.profile.name} 🌞", colour: Colors.orange),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HighlightedText(label: "Height 📏", colour: Colors.orange),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("${profileChangeNotifier.profile.height}cm", style: TextStyle(fontSize: 16),),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HighlightedText(label: "Weight ⚖️", colour: Colors.orange),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("${profileChangeNotifier.profile.weight}kg", style: const TextStyle(fontSize: 16),),
            )
          ],
        ),
        ElevatedButton.icon(
            onPressed: goToEditProfilePage,
            icon: const Icon(Icons.note_alt, color: Colors.white,),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            label: const Text("Update Details", style: TextStyle(color: Colors.white),)
        ),
      ],
    ),
  );
  }
}
