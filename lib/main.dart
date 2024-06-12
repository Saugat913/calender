import 'package:calendr/api/firebase.dart';
import 'package:calendr/components/events.dart';
import 'package:flutter/material.dart';
import 'package:calendr/components/calender.dart';
//import'package:http/http.dart';
//import 'package:nepali_utils/nepali_utils.dart';

void main(List<String> args) {
  //final store=FireStore.init(apiKey: "dchdbch");
  //await store.obtainCredentials();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
   Stream<bool> getLoadinStatus()=>Stream<bool>.periodic(Duration(seconds: 10),((computationCount) => computationCount%2==0?true:false));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Title PlaceHolder"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (() {}), icon: Icon(Icons.add),iconSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: IconButton(onPressed: (() {}), icon: Icon(Icons.settings)),
                    ),
                    IconButton(icon: CircleAvatar(radius: 20,),onPressed: ()async{
                         final firebase=Firebase.init(clientId: "17028056165-lu0t49dvab4r1nhbdcimkocth96ailqg.apps.googleusercontent.com",apiKey: "AIzaSyDbjyBDDNuCjV0XtFT7KXXILYIWedxtURM",clientSecret: "2aVoWgrUiE6qpuTuZ2jPSfjy");
                         firebase.auth();
                         
                    },),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
                child:Row(
              children: [
                Expanded(child: const Calender()),
                Expanded(child: StreamBuilder<bool>(
                  stream: getLoadinStatus(),
                  builder: (context, snapshot) {
                    return Events(isLoading: snapshot.data==null?true:snapshot.data!,);
                  }
                ))
              ],
            )),
          ],
        ),
      ),
    );
  }
}
