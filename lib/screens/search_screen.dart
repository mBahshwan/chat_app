import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/screens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  final String user;
  SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    // setState(() {
    //   searchResult = [];
    //   isLoading = true;
    // });
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .where("nickName", isEqualTo: searchController.text)
    //     .get()
    //     .then((value) {
    //   if (value.docs.length < 1) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text("No User Found")));
    //     setState(() {
    //       isLoading = false;
    //     });
    //     return;
    //   }
    //   value.docs.forEach((user) {
    //     //     if (user.data()['email'] != widget.user.email) {
    //     searchResult.add(user.data());
    //     //  }
    //   });
    //   // setState(() {
    //   //   isLoading = false;
    //   // });
    // });
    try {
      setState(() {
        searchResult = [];
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .where("name", isEqualTo: searchController.text)
          .get()
          .then((value) {
        if (value.docs.length < 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No User Found")));
          setState(() {
            isLoading = false;
          });
        }
        value.docs.forEach((user) {
          if (user.data()['email'] != widget.user) {
            setState(() {
              searchResult.add(user.data());
              isLoading = false;
            });
          }
          setState(() {
            isLoading = false;
          });

          // print(searchResult);
        });
        // searchResult =
        //     value.docs.map((e) => UserModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: tabColor,
        title: Text("Search your Friend"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    style: TextStyle(color: textColor),
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: "type username....",
                        hintStyle: TextStyle(color: textColor),
                        fillColor: searchBarColor,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                          10,
                        ))),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(
                    Icons.search,
                    color: textColor,
                  ))
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Card(
                          color: tabColor,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchResult[index]["image"]),
                            ),
                            title: Text(searchResult[index]['name']),
                            trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.text = "";
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              friendEmail: searchResult[index]
                                                  ['email'],
                                              date: searchResult[index]['date']!
                                                  .toDate(),
                                              isOnline: searchResult[index]
                                                  ['isOnline'],
                                              //    currentUser: widget.user,
                                              friendId: searchResult[index]
                                                  ['uid'],
                                              friendName: searchResult[index]
                                                  ['name'],
                                              friendImage: searchResult[index]
                                                  ['image'])));
                                },
                                icon: Icon(Icons.message)),
                          ),
                        ),
                      );
                    }))
          else if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
