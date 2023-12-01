import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/viewModels/userInformation_viewmodel.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final TextEditingController nameController = TextEditingController();
  FocusNode name = FocusNode();
  //File? image;

  // void selectImage() async {
  //   image = await pickImageFromGallery(context);
  //   setState(() {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    print(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  // void storeUserData() async {
  //   String name = nameController.text.trim();

  //   if (name.isNotEmpty) {
  //     _functions.saveUserDataToFirebase(
  //         name: name, profilePic: image, context: context);
  //   }
  // }

  // Future<List<UserModel>> getData() async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   QuerySnapshot<Map<String, dynamic>> response =
  //       await firebaseFirestore.collection("users").get();

  //   return response.docs.map((e) => UserModel.fromJson(e.data())).toList();
  // }

  // @override
  // void initState() {
  //   print(getData().then((value) => value.where(
  //       (element) => element.uid == FirebaseAuth.instance.currentUser!.uid)));

  //   super.initState();
  // }
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
              child: Form(
            key: Provider.of<UserInformationViewmodel>(context).formKey,
            child: FutureBuilder<UserModel>(
              future: UserInformationViewmodel.getCurrentUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.09,
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                Provider.of<UserInformationViewmodel>(context,
                                                listen: false)
                                            .image ==
                                        null
                                    ? NetworkImage(
                                        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                                      ) as ImageProvider
                                    : FileImage(
                                        Provider.of<UserInformationViewmodel>(
                                                context)
                                            .image!),
                            radius: 64,
                          ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () async {
                                await Provider.of<UserInformationViewmodel>(
                                        context,
                                        listen: false)
                                    .pickImageFromGallery(context);
                              },
                              //   onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: greyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "this field can't be empty";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) =>
                                    FocusScope.of(context).unfocus(),
                                controller: nameController,
                                cursorColor: textColor,
                                style: const TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "enter your name",
                                  hintStyle: TextStyle(color: textColor),
                                  filled: true,
                                  fillColor: searchBarColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: textColor),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {
                                // await FirebaseAuth.instance.signOut();
                                // await sharedPreferences!.setBool("editComplete", true);
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => LoginScreen(),
                                //     ),
                                //     (route) => false);
                                // UserModel _user = UserModel(
                                //     name: nameController.text,
                                //     password: snapshot.data!.password,
                                //     email: FirebaseAuth
                                //         .instance.currentUser!.email,

                                //     isOnline: false,
                                //     image:
                                //         Provider.of<UserInformationViewmodel>(
                                //                 context,
                                //                 listen: false)
                                //             .downloadUrl,
                                //     date: Timestamp.fromDate(DateTime.now()),
                                //     uid:
                                //         FirebaseAuth.instance.currentUser!.uid);

                                Provider.of<UserInformationViewmodel>(context,
                                        listen: false)
                                    .storeFileToFirebase(
                                        Provider.of<UserInformationViewmodel>(
                                                context,
                                                listen: false)
                                            .image!,
                                        nameController.text,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        snapshot.data!.password!,
                                        FirebaseAuth
                                            .instance.currentUser!.email!,
                                        context);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
        ));
  }
}
