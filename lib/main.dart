import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mlkit/firebase_options.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//variable
  late TextEditingController controller;
  late LanguageIdentifier identifier;
  String langSimple="";
  String langMultiple="";



  //méthode

  getSimple() async{
    if(controller.text == "") return;
    String phrase = controller.text; 
    final langageIdentified = await identifier.identifyLanguage(phrase);
    setState(() {
      langSimple = langageIdentified;
      
    });

  }

  getMultiple() async{
    if(controller.text == "") return;
    String phrase = controller.text;
    final LangageIdentified = await identifier.identifyPossibleLanguages(phrase);
    if(LangageIdentified.isEmpty){
      langMultiple =" Nous n'avos pas pu trouver de corrsepondance";
    }
    else{
      for(var lang in LangageIdentified){
        setState(() {
         langMultiple += "${lang.languageTag}, confiance : ${lang.confidence * 100.toInt()} %";

        });
      }


    }
  }
  
  @override
  void initState() {

    controller = TextEditingController();
    identifier = LanguageIdentifier(confidenceThreshold: 0.4);
    super.initState();
  }
  //traduction de langue

   @override
  void dispose() {
   controller.dispose();
   identifier.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("hello"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Text vide"
            ),
          ),


          Text("Texte simple identifier : $langSimple"),
          Text("Texte multiple identifier: $langMultiple"),
          ElevatedButton(
            onPressed: getSimple, 
            child: const Text("Une langue")
          ),
          ElevatedButton(
            onPressed: getMultiple, 
            child: const Text("Plusieur Langues")
            ),
        ],
      )



    );
  }
}
