import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:notes_firebase_app/auth_screens/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  Future<bool> isDisplay() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getBool("isDisplay") == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isDisplay().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.black,
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Welcome to the Vocabulary App",
                style: TextStyle(
                    fontSize: 20, color: Colors.blue, letterSpacing: 0.4),
              ),
              SizedBox(height: 20),
              Text(
                "You can store your words here",
                style: TextStyle(
                    color: Colors.grey, fontSize: 18, letterSpacing: 0.2),
              ),
            ],
          ),
          image: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://images.pexels.com/photos/4151043/pexels-photo-4151043.jpeg?cs=srgb&dl=pexels-eunice-lui-4151043.jpg&fm=jpg")),
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Best way to learn new words",
                style: TextStyle(
                    fontSize: 20, color: Colors.blue, letterSpacing: 0.4),
              ),
              SizedBox(height: 20),
              Text(
                "You will never lose your words",
                style: TextStyle(
                    color: Colors.grey, fontSize: 18, letterSpacing: 0.2),
              ),
            ],
          ),
          image: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://images.pexels.com/photos/4151043/pexels-photo-4151043.jpeg?cs=srgb&dl=pexels-eunice-lui-4151043.jpg&fm=jpg")),
          ),
        ),
      ],
      showBackButton: false,
      showSkipButton: true,
      next: const Text("Next"),
      skip: const Text("Skip"),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      showDoneButton: true,
      onDone: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool("isDisplay", true);
        print("Value is stored");
      },
    );
  }
}
