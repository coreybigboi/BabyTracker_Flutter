import 'package:baby_tracker_flutter/Entity/Profile.dart';
import 'package:baby_tracker_flutter/Entity/ProfileChangeNotifier.dart';
import 'package:baby_tracker_flutter/UI/common_widgets/HighlightedText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final Profile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  // State
  String saveBtnLbl = "Save Details";

  // Controllers
  final TextEditingController inputNameController = TextEditingController();
  final TextEditingController inputHeightController = TextEditingController();
  final TextEditingController inputWeightController = TextEditingController();

  void submit(){
    setState(() {
      saveBtnLbl = "Saving...";
    });

    Profile updated = Profile(
        name: inputNameController.text,
        dob: widget.profile.dob,
        height: int.parse(inputHeightController.text),
        weight: int.parse(inputWeightController.text)
    );
    Provider.of<ProfileChangeNotifier>(context, listen: false).updateProfile(updated, onSuccessfulUpdate);
  }

  void onSuccessfulUpdate(){
    Navigator.pop(context);
    _showToast();
  }

  void _showToast() {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Profile successfully updated!"),
            content: Image.asset("assets/party.gif"),
            actions: [
              TextButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("ok", style: TextStyle(color: Colors.blue, fontSize: 20),),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    inputNameController.text = widget.profile.name;
    inputHeightController.text = widget.profile.height.toString();
    inputWeightController.text = widget.profile.weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Edit Profile 📝"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const HighlightedText(label: "Name 📖", colour: Colors.orange),
              TextField(
                controller: inputNameController,
                decoration: const InputDecoration(
                  hintText: "Write name here",
                ),
              ),
              const HighlightedText(label: "Height (cm) 📏", colour: Colors.orange),
              TextField(
                controller: inputHeightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(

                  hintText: "Input height here",
                ),
              ),
              const HighlightedText(label: "Weight (kg) ⚖️", colour: Colors.orange),
              TextField(
                controller: inputWeightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Input weight here",
                ),
              ),
              ElevatedButton.icon(
                  onPressed: submit,
                  icon: const Icon(Icons.save, color: Colors.white,),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  label: Text(saveBtnLbl, style: const TextStyle(color: Colors.white),)
              ),
            ],
          ),
        )
      ),
    );
  }
}
