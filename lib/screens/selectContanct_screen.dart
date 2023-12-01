// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:whatsapp_clone/common/colors.dart';
// import 'package:whatsapp_clone/common/utils.dart/snakbar.dart';
// import 'package:whatsapp_clone/models/user_model.dart';
// import 'package:whatsapp_clone/screens/chat_screen.dart';

// class SelectContactScreen extends StatefulWidget {
//   const SelectContactScreen({super.key});

//   @override
//   State<SelectContactScreen> createState() => _SelectContactScreenState();
// }

// class _SelectContactScreenState extends State<SelectContactScreen> {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   Future<List<Contact>> getContacts() async {
//     List<Contact> contacts = [];
//     try {
//       if (await FlutterContacts.requestPermission()) {
//         contacts = await FlutterContacts.getContacts(withProperties: true);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return contacts;
//   }

//   void selectContact(Contact selectedContact, BuildContext context) async {
//     try {
//       var userCollection = await firestore.collection('users').get();
//       bool isFound = false;

//       for (var document in userCollection.docs) {
//         var userData = UserModel.fromJson(document.data());
//         String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
//           ' ',
//           '',
//         );
//         print("${userData.phoneNumber}");
//         if (selectedPhoneNum == userData.phoneNumber) {
//           setState(() {
//             isFound = true;
//           });

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatScreen(
//                     friendId: userData.uid.toString(),
//                     friendName: userData.name.toString(),
//                     friendImage: userData.image.toString()),
//               ));
//         }
//       }

//       if (!isFound) {
//         showSnackBar(
//           context: context,
//           content: 'This number does not exist on this app.',
//         );
//       }
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // SelectContantFunctuions _select = SelectContantFunctuions();
//     return Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           backgroundColor: searchBarColor,
//           title: const Text('Select contact'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 showSearch(context: context, delegate: DataSearch());
//               },
//               icon: const Icon(
//                 Icons.search,
//               ),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.more_vert,
//               ),
//             ),
//           ],
//         ),
//         body: FutureBuilder<List<Contact>>(
//           future: getContacts(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () =>
//                           selectContact(snapshot.data![index], context),
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: ListTile(
//                           title: Text(
//                             snapshot.data![index].displayName,
//                             style:
//                                 const TextStyle(fontSize: 18, color: textColor),
//                           ),
//                           leading: snapshot.data![index].photo == null
//                               ? const CircleAvatar(
//                                   backgroundImage: NetworkImage(
//                                     'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
//                                   ),
//                                   radius: 30,
//                                 )
//                               : CircleAvatar(
//                                   backgroundImage:
//                                       MemoryImage(snapshot.data![index].photo!),
//                                   radius: 50,
//                                 ),
//                         ),
//                       ),
//                     );
//                   });
//             }
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ));
//   }
// }

// class DataSearch extends SearchDelegate<int> {
//   List<Contact>? filterList;

//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   Future<List<Contact>> getContacts() async {
//     List<Contact> contacts = [];
//     try {
//       if (await FlutterContacts.requestPermission()) {
//         contacts = await FlutterContacts.getContacts(withProperties: true);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     return contacts;
//   }

//   void selectContact(Contact selectedContact, BuildContext context) async {
//     try {
//       var userCollection = await firestore.collection('users').get();
//       bool isFound = false;

//       for (var document in userCollection.docs) {
//         var userData = UserModel.fromJson(document.data());
//         String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
//           ' ',
//           '',
//         );
//         print("${userData.phoneNumber}");
//         if (selectedPhoneNum == userData.phoneNumber) {
//           isFound = true;

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatScreen(
//                     friendId: userData.uid.toString(),
//                     friendName: userData.name.toString(),
//                     friendImage: userData.image.toString()),
//               ));
//         }
//       }

//       if (!isFound) {
//         showSnackBar(
//           context: context,
//           content: 'This number does not exist on this app.',
//         );
//       }
//     } catch (e) {
//       showSnackBar(context: context, content: e.toString());
//     }
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: Icon(Icons.clear),
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         icon: Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Text("");
//     // return Scaffold(
//     //   floatingActionButton: FloatingActionButton(
//     //       heroTag: null,
//     //       onPressed: () {
//     //         Navigator.of(context).pushAndRemoveUntil(
//     //             MaterialPageRoute(
//     //               builder: (context) =>
//     //             ),
//     //             (route) => false);
//     //       },
//     //       child: Icon(Icons.add)),
//     //   backgroundColor: Colors.blue[400],
//     //   body: CustomerInformation(
//     //     id: id.toString(),
//     //   ),
//     // );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder<List<Contact>>(
//         future: getContacts(),
//         builder: (context, snapshot) {
//           filterList = snapshot.data
//               ?.where((element) => element.displayName.startsWith(query))
//               .toList();
//           if (snapshot.hasData) {
//             return ListView.builder(
//                 itemCount:
//                     query.isEmpty ? snapshot.data!.length : filterList!.length,
//                 itemBuilder: (context, index) {
//                   return InkWell(
//                     onTap: () {
//                       query.isEmpty
//                           ? selectContact(snapshot.data![index], context)
//                           : selectContact(filterList![index], context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: ListTile(
//                         title: query.isEmpty
//                             ? Text(
//                                 snapshot.data![index].displayName,
//                                 style: const TextStyle(
//                                     fontSize: 18, color: Colors.black),
//                               )
//                             : Text(
//                                 filterList![index].displayName,
//                                 style: const TextStyle(
//                                     fontSize: 18, color: Colors.black),
//                               ),
//                         leading: query.isEmpty
//                             ? snapshot.data![index].photo == null
//                                 ? const CircleAvatar(
//                                     backgroundImage: NetworkImage(
//                                       'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
//                                     ),
//                                     radius: 30,
//                                   )
//                                 : CircleAvatar(
//                                     backgroundImage: MemoryImage(
//                                         snapshot.data![index].photo!),
//                                     radius: 50,
//                                   )
//                             : filterList![index].photo == null
//                                 ? const CircleAvatar(
//                                     backgroundImage: NetworkImage(
//                                       'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
//                                     ),
//                                     radius: 30,
//                                   )
//                                 : CircleAvatar(
//                                     backgroundImage:
//                                         MemoryImage(filterList![index].photo!),
//                                     radius: 50,
//                                   ),
//                       ),
//                     ),
//                   );
//                 });
//             // return ListView.builder(
//             //   itemCount:
//             //       query.isEmpty ? snapshot.data!.length : filterList!.length,
//             //   itemBuilder: (context, i) {
//             //     return InkWell(
//             //       onTap: () {

//             //         query = query.isEmpty
//             //             ? "${snapshot.data![i].name}"
//             //             : "${filterList![i].name}";

//             //         showResults(context);
//             //       },
//             //       child: ListTile(
//             //           leading: Icon(Icons.person, color: Colors.black),
//             //           title: query.isEmpty
//             //               ? Text("${snapshot.data![i].name}")
//             //               : Text("${filterList![i].name}")),
//             //     );
//             //   },
//             // );
//           }
//           return Center(child: CircularProgressIndicator());
//         });
//   }
// }
