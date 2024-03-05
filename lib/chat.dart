import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget{
  const Chat({super.key});

  @override
  State<StatefulWidget> createState() => _Chat();

}

class _Chat extends State<Chat>{

  List<Messages> messages = [];
  DatabaseReference database = FirebaseDatabase.instance.ref("data");
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: getBottomView(),
    );
  }

  AppBar getAppBar(){
    return AppBar(elevation: 5,title: const Text("Chat"),);
  }

  Widget getBody(){
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (c,i){
          if(auth.currentUser?.uid == messages[i].id){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                  child: Text(
                    messages[i].user??"null",
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      color: Colors.green
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 50,top: 0,right: 10,bottom: 5),
                  child: Text(
                    messages[i].message??"null",
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            );
          }else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                  child: Text(
                    messages[i].user??"null",
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      color: Colors.blue
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 50,top: 0,left: 10,bottom: 5),
                  child: Text(
                    messages[i].message??"null",
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            );
          }
        }
    );
  }

  Widget getBottomView(){
    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(child: TextField(decoration: const InputDecoration(hintText: "Type message.."),controller: controller,)),
          IconButton(onPressed: (){
            Messages message = Messages(auth.currentUser?.uid, controller.text, auth.currentUser?.displayName, DateTime.now().millisecondsSinceEpoch);
            sendMessage(message);
            controller.text = "";
          }, icon: const Icon(Icons.send))
        ],
      ),
    );
  }

  void sendMessage(Messages message) async{
    await database.child("chat").push().set(message.toMap());
  }

  void getMessages() async{
    database.child("chat").onChildAdded.listen((event) {
      Map<String,dynamic> message = event.snapshot.value as Map<String,dynamic>;
      setState(() {
        messages.add(Messages.fromMap(message));
      });
    });
  }

}

class Messages{
  String? message;
  String? user;
  String? id;
  int? time;
  Messages(this.id,this.message,this.user,this.time);

  factory Messages.fromMap(Map<String,dynamic> map){
    return Messages(
        map["id"],
        map["message"],
        map["user"],
        map["time"]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "message": message,
      "user": user,
      "time": time
    };
  }
}