import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/chat_screen.dart';
import 'package:whatsapp_clone/screens/login_screen.dart';
import 'package:whatsapp_clone/screens/search_screen.dart';
import 'package:whatsapp_clone/services/zegoCloud_services.dart';
import 'package:whatsapp_clone/viewModels/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String defaultImage =
      "https://oedit.colorado.gov/sites/coedit/files/styles/contact_crop/public/2020-11/Person%20Icon_12.png?h=87136cbf";
  @override
  void initState() {
    notificationService.getTokent();
    WidgetsBinding.instance.addObserver(this);
    ZegoCloudServices.initZegoCloud(FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.email!);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("$state===================================");
    switch (state) {
      case AppLifecycleState.resumed:
        Provider.of<HomeViewmodel>(context, listen: false)
            .updateUserData({"isOnline": true, "date": DateTime.now()});
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        Provider.of<HomeViewmodel>(context, listen: false)
            .updateUserData({"isOnline": false});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        // appBar: AppBar(
        //   title: Text('Home'),
        //   centerTitle: true,
        //   backgroundColor: appBarColor,

        //   // IconButton(
        //   //     onPressed: () async {
        //   //       await GoogleSignIn().signOut();
        //   //       await FirebaseAuth.instance.signOut();
        //   //       Navigator.pushAndRemoveUntil(
        //   //           context,
        //   //           MaterialPageRoute(builder: (context) => LogInScreen()),
        //   //           (route) => false);
        //   //     },
        //   //     icon: Icon(Icons.logout))
        // ),
        body: Consumer<HomeViewmodel>(
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: tabColor,
                  expandedHeight: 70,
                  floating: true,
                  elevation: 0,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    //  title: Text('Sliver AppBar Example'),
                    background: FutureBuilder<UserModel>(
                      future: value.getCurrentUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("${snapshot.data!.image}");
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: backgroundColor,
                                      radius: 40,
                                      backgroundImage: snapshot.data!.image ==
                                                  null ||
                                              snapshot.data!.image!.isEmpty
                                          ? NetworkImage(defaultImage)
                                          : NetworkImage(
                                              snapshot.data!.image.toString())),
                                  Text(
                                    "${snapshot.data!.name}",
                                    style: TextStyle(
                                        color: blackColor, fontSize: 18),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                            (route) => false);
                                      },
                                      icon: const Icon(Icons.logout)),
                                ]),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                    // background:
                    // Image.network(
                    //   defaultImage,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 900,
                    child: StreamBuilder<List<MessageModel>>(
                        stream: value.getAllMessageStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // ignore: prefer_is_empty
                            if (snapshot.data!.length < 1) {
                              return const Center(
                                child: Text(
                                  "No Chats Availables !",
                                  style: TextStyle(color: textColor),
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var friendId = snapshot.data![index].uid;
                                  var lastMsg =
                                      snapshot.data![index].lastMessage;
                                  return FutureBuilder(
                                    future: value.getFriend(friendId),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        UserModel friend = snapshot.data!;
                                        return Card(
                                          color: messageColor,
                                          child: ListTile(
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              child: CachedNetworkImage(
                                                imageUrl: friend.image!,
                                                placeholder: (conteext, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                ),
                                                height: 50,
                                              ),
                                            ),
                                            title: Text(
                                              friend.name!,
                                              style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: 18),
                                            ),
                                            subtitle: Container(
                                              child: Text(
                                                lastMsg,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            onTap: () {
                                              print(friend.token);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                              //    currentUser: widget.user,
                                                              friendEmail:
                                                                  friend.email!,
                                                              date: friend.date!
                                                                  .toDate(),
                                                              isOnline: friend
                                                                  .isOnline!,
                                                              friendId:
                                                                  friendId,
                                                              friendName:
                                                                  friend.name!,
                                                              friendImage: friend
                                                                  .image!)));
                                            },
                                          ),
                                        );
                                      }
                                      return const LinearProgressIndicator();
                                    },
                                  );
                                });
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                )
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: tabColor,
          child: const Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                      FirebaseAuth.instance.currentUser!.email.toString()),
                ));
          },
        ));
  }
}
