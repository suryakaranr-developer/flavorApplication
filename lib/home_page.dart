import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavors/remoteConfigurationServices.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'flavor_config.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}
  class _HomePageState extends State<HomePage> {
    final remoteConfig = RemoteConfigService();
    String heading = "Loading...";

    @override
    void initState() {
      super.initState();
      loadConfig();
    }

    Future<void> loadConfig() async {
      setState(() {
        heading = remoteConfig.heading;
      });
    }
    //final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
             Center(
              child: Text(
            RemoteConfigService().heading,
                style: TextStyle(fontSize: 22),
              ),
            ),
            if (!FlavorConfig.isProd) _buildBanner(),

            _buildGoogleSignIn(),

          ],
        ),
      );
    }

    Widget _buildBanner() {
      return Positioned(
        top: 40,
        left: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: FlavorConfig.isDev ? Colors.red : Colors.orange,
          child: Text(
            FlavorConfig.instance.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Widget _buildGoogleSignIn() {
      return Positioned(
        bottom: 150,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () async{

             final user= await googleSignIn();

            },
            child: const Icon(
              Icons.g_mobiledata_sharp,
              size: 80,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    Future<User> googleSignIn() async {
      try {

        print(await PackageInfo.fromPlatform());

        final GoogleSignIn signIn = GoogleSignIn.instance;

        await signIn.initialize(
          serverClientId: "608305254970-e648jq95c86q8ma6geg14iceifh2gqd2.apps.googleusercontent.com",
        );



        final GoogleSignInAccount? googleUser =
        await signIn.authenticate();

        if (googleUser == null) {
          throw Exception("User cancelled Google Sign-In");
        }

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final userCredential =
        await _auth.signInWithCredential(credential);

        final user = userCredential.user;

        if (user == null) {
          throw Exception("Firebase user is null after sign-in");
        }

        return user;
      } catch (e, stackTrace) {
        print("Google Sign-In Error: $e");
        rethrow;
      }
    }




  }

