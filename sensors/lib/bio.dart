import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sensors/mysensor.dart';

class BIO extends StatefulWidget {
  const BIO({super.key});

  @override
  State<BIO> createState() => _BIOState();
}

class _BIOState extends State<BIO> {
  late final LocalAuthentication auth;
  bool _supportStatus = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupport) => setState(() {
          _supportStatus = isSupport;
        }));
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authentication Demo',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Authentication Successful'),
              content: Text('You want to go to Sensor Page'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySenSor(),
                        ));
                  },
                  child: Text('Go to Sensor Page'),
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Authentication'),
        leading: Icon(Icons.fingerprint),
        centerTitle: false,
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.face_2_sharp,
                  size: 100,
                ),
              ),
            ),
            Text(
              'Log in to Sensor Page',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            _supportStatus ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.greenAccent[50]),
              onPressed: _authenticate,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.fingerprint_outlined,
                  color: Colors.green,
                  size: 50,
                ),
              ),
            ) : Text('Device does not support Biometric Authentication')
          ],
        ),
      ),
    );
  }
}
