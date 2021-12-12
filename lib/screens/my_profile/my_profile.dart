import 'package:flutter/material.dart';
import 'package:medx/config/colors.dart';
import 'package:medx/models/user_model.dart';
import 'package:medx/providers/user_provider.dart';
import 'package:medx/screens/home/drawer_side.dart';
import 'package:medx/screens/check_out/delivery_details/delivery_details.dart';
import 'package:medx/screens/review_cart/review_cart.dart';
import 'package:medx/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medx/auth/sign_in.dart';

class MyProfile extends StatefulWidget {
  UserProvider userProvider;
  MyProfile({this.userProvider});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget listTile({IconData icon, String title,Function onTap}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
      drawer: DrawerSide(
        userProvider: widget.userProvider,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: primaryColor,
              ),
              Container(
                height: 548,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          height: 80,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.userName,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textColor),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(userData.userEmail),
                                ],
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: primaryColor,
                                child: CircleAvatar(
                                  radius: 12,
                                  child: Icon(
                                    Icons.edit,
                                    color: primaryColor,
                                  ),
                                  backgroundColor: scaffoldBackgroundColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    listTile(icon: Icons.add_shopping_cart, title: "My Cart",
                    onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReviewCart(),
                          ),
                        );
                      },
                    ),
                    listTile(
                        icon: Icons.location_on_outlined,
                        title: "My Delivery Address",
                        onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DeliveryDetails(),
                          ),
                        );
                      }),
                    
                    listTile(icon: Icons.add_chart, title: "About",
                    onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    ),
                    listTile(
                        icon: Icons.exit_to_app_outlined, title: "Log Out",
                        onTap: () async{
                          final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                          await _firebaseAuth.signOut();
                          Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                        );
                       },
                        ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userData.userImage ??
                        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmedex.com.bd%2Fapp&psig=AOvVaw13G8hVMSg9TvsNdjUzhrL_&ust=1639407682770000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCJiUqNfD3vQCFQAAAAAdAAAAABAD",
                  ),
                  radius: 45,
                  backgroundColor: scaffoldBackgroundColor),
            ),
          )
        ],
      ),
    );
  }
}
