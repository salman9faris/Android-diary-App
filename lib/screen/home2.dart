import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage1 extends StatefulWidget {
  const Homepage1({Key? key}) : super(key: key);

  @override
  State<Homepage1> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 10),
            child: ListTile(
              title: Text("Hi salman2",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 48,
                      fontWeight: FontWeight.w500)),
              subtitle: Text("Good Morning..!",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              //tileColor: Colors.orange,
              trailing: Icon(
                Icons.circle_sharp,
                size: 88,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 35),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 55,
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
          /*ElevatedButton(
            child: Icon(Icons.add_circle),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xfff8f2cf)),
              padding: MaterialStateProperty.all(EdgeInsets.all(15)),
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 25)),
            ),
          ),
*/
          SizedBox(height: 15),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Diarytile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Diarytile extends StatelessWidget {
  const Diarytile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("diary").snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[i];
                  return Card(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(
                        documentSnapshot['diarybody'],
                      ),
                      subtitle: Text(documentSnapshot['diarytitle']),
                    ),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}






/* Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            color: Color(0xffcfebf2),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          title: Text("Hi all",
              style: TextStyle(
                  fontSize: 28,
                  color: Color(0xff2b6673),
                  fontWeight: FontWeight.w500)),
          subtitle: ElevatedButton(
            onPressed: () async {
              print("enter");
              final FirebaseAuth auth = FirebaseAuth.instance;
              print(auth);
              inputData(auth);
            },
            child: Text("back"),
          ),
        ),
      ),
    );
  }
}
*/