import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddorEdit extends StatefulWidget {
  const AddorEdit({Key? key}) : super(key: key);

  @override
  _AddorEditState createState() => _AddorEditState();
}

class _AddorEditState extends State<AddorEdit> {
  bool edit = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffeff1f2),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              (edit == false)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconBotton(context, Icons.arrow_back_rounded),
                        iconBotton(context, Icons.edit),
                        //print("truee");
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconBotton(context, Icons.arrow_back_rounded),
                        //iconBotton(context, Icons.edit),
                      ],
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title(context, "Add", 35.0, FontWeight.normal, 4.0),
                    title(context, "New Diary", 38.0, FontWeight.bold, 4.0),
                    SizedBox(
                      height: 30,
                    ),
                    title(context, "Title", 22.0, FontWeight.bold, 1.0),
                    textFormField(context, 55.0, "title"),
                    SizedBox(
                      height: 20,
                    ),
                    title(context, "Body", 22.0, FontWeight.bold, 1.0),
                    textFormField(context, 250.0, "write here..."),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff2b6673),
                              textStyle: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container textFormField(BuildContext context, height, hintText) {
    return Container(
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black, fontSize: 18)),
        ));
  }

  IconButton iconBotton(BuildContext context, icon) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(icon),
      color: Theme.of(context).primaryColor,
      iconSize: 30,
    );
  }

  Text title(BuildContext context, title, size, fontWeight, letterSpacing) {
    return Text(
      title,
      style: TextStyle(
          fontSize: size,
          color: Theme.of(context).primaryColor,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing),
    );
  }
}
