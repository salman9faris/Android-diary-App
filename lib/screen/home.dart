import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String diarytitle = "";
  String diarybody = "";

  ScrollController _scrollController =
      new ScrollController(); // set controller on scrolling
  bool _show = true;
  @override
  void initState() {
    super.initState();
    //addItemsToTheList();
    //handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  createDiary() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("diary").doc(diarytitle);
    Map<String, String> diary = {
      "diarytitle": diarytitle,
      "diarybody": diarybody
    };
    documentReference.set(diary).whenComplete(() {
      print("input added");
    });
  }

  deleteDiary(diarytitle) {
    try {
      FirebaseFirestore.instance.collection("diary").doc(diarytitle).delete();
    } catch (e) {
      print(e);
    }
  }

  void inputData(auth) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    print("uid");
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 250.0,
              toolbarHeight: 200,
              floating: true,
              pinned: true,
              title: ListTile(
                title: Text("Hi salman",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 48,
                        fontWeight: FontWeight.w500)),
                subtitle: Text("Good Morning..!",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
              ),
              actions: [
                Icon(
                  Icons.circle_sharp,
                  size: 105,
                  color: Colors.grey,
                ),
              ],
              bottom: AppBar(
                elevation: 0.0,
                toolbarHeight: 60,
                backgroundColor: Colors.white,
                title: Container(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Type in your text",
                        fillColor: Colors.white70),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("diary").snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          QueryDocumentSnapshot documentSnapshot =
                              snapshots.data!.docs[i];
                          return Container(
                            //height: 100,
                            child: Card(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 5, left: 5),
                              child: Dismissible(
                                key: UniqueKey(),
                                resizeDuration: Duration(milliseconds: 200),
                                background: Container(
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 26.0,
                                      ),
                                    ],
                                  ),
                                ),
                                // only allows the user swipe from right to left
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) {
                                  setState(() {
                                    deleteconformation(
                                        context, documentSnapshot);
                                  });
                                },
                                child: ListTile(
                                  /*trailing: IconButton(
                                    icon: new Icon(Icons.delete),

                                    onPressed: () {
                                      //showToast();
                                    }/ // null disables the button

                                    color: Theme.of(context).primaryColor,
                                  ),*/
                                  title: Text(
                                    documentSnapshot['diarytitle'],
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    documentSnapshot['diarybody'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount:
                            snapshots.data!.docs.length, // 1000 list items
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text("please wait...."),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: _show,
          child: FloatingActionButton(
              // isExtended: true,
              backgroundColor: Colors.green,
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text("Add your Today"),
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 110.0,
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (String title) {
                                    diarytitle = title;
                                  },
                                ),
                                SingleChildScrollView(
                                  child: TextField(
                                    // maxLines: 15,
                                    onChanged: (String body) {
                                      diarybody = body;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                dialogButton(
                                    context,
                                    Theme.of(context).primaryColor,
                                    "cancel",
                                    null),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      createDiary();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Add"),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Theme.of(context)
                                                .primaryColor;
                                          return Colors.green;
                                        },
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              }),
        ));
  }

  Future<dynamic> deleteconformation(
      BuildContext context, QueryDocumentSnapshot<Object?> documentSnapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 50,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Delete"),
              insetPadding: EdgeInsets.symmetric(
                horizontal: 50.0,
                vertical: 110.0,
              ),
              content: Text("are you sure to delete"),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    dialogButton(
                      context,
                      Theme.of(context).primaryColor,
                      "cancel",
                      null,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    dialogButton(
                      context,
                      Colors.red,
                      "Delete",
                      documentSnapshot['diarytitle'],
                    ),
                    //showToast(),
                  ],
                )
              ],
            ),
          );
        });
  }

  ElevatedButton dialogButton(
      BuildContext context, color, text, functionapplied) {
    return ElevatedButton(
        onPressed: () {
          deleteDiary(functionapplied);
          Navigator.of(context).pop();
        },
        child: Text(text),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return color;
              return color;
            },
          ),
        ));
  }
}

/*void showToast() {
  Fluttertoast.showToast(
      msg: 'This is toast notification',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.yellow);
}*/
