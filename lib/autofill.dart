import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:device_info/device_info.dart';
import 'package:esyitr/otpVerify.dart';
import 'package:http/http.dart' as http;
import 'package:telephony/telephony.dart';

class AutoFill extends StatefulWidget {
  @override
  _AutoFillState createState() => _AutoFillState();
}

class _AutoFillState extends State<AutoFill> {
  String _mobileNumber = '';
  static const platform = const MethodChannel('sendSms');

  TextEditingController mobileController = TextEditingController();

  Future registerNumber(String phone) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    final url = "https://ezyitr.com/testing/public/api/searchUser";
    Map map = {
      "wpmobile": phone,
    };

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();

    var parsedJson = json.decode(reply);
    print(parsedJson);
    var jsonValue = json.decode(parsedJson['status'].toString());
    print(jsonValue);
    if (!mounted) return;
    if (jsonValue == 200) {
      // return _showDialog();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerify(
                    number: _mobileNumber,
                  )));
    } else {
      return _showDialog();
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // void initState() {
  //   super.initState();
  //   Timer.run(() {
  //     try {
  //       InternetAddress.lookup('google.com').then((result) {
  //         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //           print('connected');
  //         } else {
  //           _connectivity(); // show dialog
  //         }
  //       }).catchError((error) {
  //         _connectivity(); // show dialog
  //       });
  //     } on SocketException catch (_) {
  //       _showDialog();
  //       print('not connected'); // show dialog
  //     }
  //   });
  // }

  // void _connectivity() {
  //   // dialog implementation
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       // title: Text("Internet needed!"),
  //       content: Text("No Internet Connection"),
  //       actions: <Widget>[
  //         TextButton(
  //             child: Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             })
  //       ],
  //     ),
  //   );
  // }

  Future<void> startService() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.messages");
      String data = await methodChannel.invokeMethod("startService");
      print(data);
      setState(() {});
    }
  }

  // Future<Null> sendSms() async {
  //   print("SendSMS");
  //   try {
  //     final String result = await platform.invokeMethod(
  //         'send', <String, dynamic>{
  //       "phone": "+91XXXXXXXXXX",
  //       "msg": "Hello! I'm sent programatically."
  //     }); //Replace a 'X' with 10 digit phone number
  //     print(result);
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(
              "The number you are entered is not a register number. Please provide a valid number."),
          actions: <Widget>[
            new TextButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit() async {
    String deviceId = await _getId();
    print(deviceId);
    // _mobileNumber = mobileController.text;
    // print(_mobileNumber);
    // _connectivity();
    FocusScope.of(context).unfocus();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => OTPVerify()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              'Enter Phone Number',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 7, left: 7),
            padding: EdgeInsets.all(18),
            child: PhoneFieldHint(
              controller: mobileController,
              autoFocus: true,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: Text(
              'Send',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              _submit();
              // sendSms();
              startService();
              String phone = mobileController.text;
              print(phone);
              var res = await registerNumber(phone);
              print(res);
              setState(() {
                _mobileNumber = phone;
                print(_mobileNumber);
              });
              //http here
              // final signCode = await SmsAutoFill().getAppSignature;
              // print(signCode);
              // FocusScope.of(context).unfocus();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => OTPVerify()));
            },
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            child: Text(
              'Please enter registered phone number',
              textAlign: TextAlign.center,
              style: TextStyle(
                // decoration: TextDecoration.underline,
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      )),
    );
  }
}
