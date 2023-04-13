
import 'package:TWatch_Manager/UI/posts/heart_chart.dart';

import '../../models/analytic_info_model.dart';
import '../../widgets/analytic_info_card.dart';
import '/UI/auth/login_screen.dart';
import '/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  // here we are passing ref of our node of which we have to fetch data from
  final ref = FirebaseDatabase.instance.ref('devices');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Main Page'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: Column(children: [
        // firebaseanimatedlist handles all the animations and other things automatically, u just pass it a reference and it returns all the
        // list items. whereas the advantage of stream builder is that firebase database returns some events that are itself streams so
        // u can get those streams.
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search by title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            )),
        Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Text('Loading'),
                // itembuilder needs 4 parameters, one is buildContext, second is datasnapshot, third one is animatio, and last one is index
                itemBuilder: (context, snapshot, animation, index) {
                  final name = snapshot.child('name').value.toString();
                  final tmp = name.split("@");
                  final device = tmp[1].split(".");
                  final id = snapshot.key;
                  if (searchFilter.text.isEmpty) {


                  return ListTile(
                      title: Text(tmp[0]),
                      subtitle: Text(device[0]),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HeartChart(device: name)));
                      },
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(snapshot.child("name").value.toString(),id.toString());
                                      },
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref.child(id.toString()).remove();
                                      },
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete'),
                                    )),
                              ]),
                    );
                  } else if (tmp[0]
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(tmp[0]),
                      subtitle:
                          Text(device[0]),
                    );
                  } else {
                    return Container();
                  }
                })),
      ]),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'name': editController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Record updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text('Update')),
            ],
          );
        });
  }
}

// Expanded(
//           child: StreamBuilder(
//           stream: ref.onValue,
//           builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (!snapshot.hasData) {
//               return CircularProgressIndicator();
//             } else {
//               Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
//               List<dynamic> list = [];
//               list.clear();
//               list = map.values.toList();

//               return ListView.builder(
//                   itemCount: snapshot.data!.snapshot.children.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(list[index]['title']),
//                       subtitle: Text(list[index]['roll-num']),
//                     );
//                   });
//             }
//           },
//         )
//         )