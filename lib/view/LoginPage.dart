import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controller/firebase_manager.dart';
import '../controller/globale.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //variable
  List<bool> selection = [true,false];
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();



  //méhode interne
  PopError(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          if(defaultTargetPlatform == TargetPlatform.iOS){
             return CupertinoAlertDialog(
               title: const Text("Erreur"),
               content: Lottie.asset("assets/error.json"),
               actions: [
                 TextButton(
                     onPressed: (){
                       Navigator.pop(context);
                     },
                     child: const Text("OK")
                 )
               ],

             );
          }
          else
            {
              return AlertDialog(
                title: const Text("Erreur"),
                content: Lottie.asset("assets/error.json"),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("OK")
                  )
                ],
              );
            }

        }
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
       padding: const EdgeInsets.all(10.0),
       child: bodyPage(),
     ),
    );
  }


  Widget bodyPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              //color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image:AssetImage("assets/zelda.png"),
                fit: BoxFit.fill
              )
            ),
          ),
          const SizedBox(height: 10),


          //toogleButton

          ToggleButtons(
              onPressed: (value){
                if(value == 0){
                  setState(() {
                    selection[0]=true;
                    selection[1]= false;
                  });

                }
                else
                  {
                    setState(() {
                      selection[0]=false;
                      selection[1]= true;
                    });

                  }
              },
              isSelected: selection,
              children:  [
                Text("Connexion"),
                Text("Inscription")
              ]
          ),


          const SizedBox(height: 10),

          //adresse mail
          TextField(
            controller: email,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              hintText: "Entrer votre adresse mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),
          ),

          const SizedBox(height: 10),


          //password
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: "Entrer votre mot de passe",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
          ),

          const SizedBox(height: 10),


          //boutton

          ElevatedButton(
              onPressed: (){
                //connexion
                if(selection[0]){
                  FirebaseManager().connect(email.text, password.text).then((value) {
                    setState(() {
                      myUser = value;
                    });


                    Navigator.push(context, MaterialPageRoute(
                        builder: (context){
                          return const DashBoard();
                        }
                    ));


                  }).catchError((onError){
                    //afficher un pop erreur de mot de passe
                    PopError();

                  });
                }
                else
                  {
                    FirebaseManager().Inscription(email.text, password.text).then((value) {
                      setState(() {
                        myUser = value;
                      });
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return const DashBoard();
                          }
                      ));

                    }).catchError((onError){
                      PopError();

                      //popUp

                    });
                  }



                //inscription
              },
              child: Text(selection[0]?"Connexion":"Inscription")
          )
        ],
      ),
    );
  }
}