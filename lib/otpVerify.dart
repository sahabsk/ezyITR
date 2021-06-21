import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

onBackgroundMessage(SmsMessage message) async{
  debugPrint("onBackgroundMessage called");
  // print(message);
}

class OTPVerify extends StatefulWidget {
  final String number;
  OTPVerify({
    Key key,
    this.number,
  }) : super(key: key);
  @override
  _OTPVerifyState createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  // String _code = '';
  String _message = "";
  final telephony = Telephony.instance;
  SmsSendStatusListener listener;



  Future createAlbum(String number, String otp) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    final url = "https://ezyitr.com/testing/public/api/storeOtp";
    Map map = {
      "wpmobile": widget.number,
      "otp": otp,
    };
    print(url);
    print(widget.number);

    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(map)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);

    var parsedJson = json.decode(reply);
    print(parsedJson);
    var jsonValue = json.decode(parsedJson['status'].toString());
    print(jsonValue);
  }



  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // final SmsSendStatusListener listener = (SendStatus status){};

  // onSendMessage(SmsMessage message){
  //   message = telephony.sendSms(to: "123456789", message: "hi, Sending message") as SmsMessage;
  //   print(message);
  // }

  onMessage(SmsMessage message) async {
    // setState(() {
    //   _message = message.body ?? "Error reading message body.";
    // });
    if (message.body.contains('Dear Taxpayer, Your EVC is')) {
      setState(() {
        _message = message.body.replaceAll(new RegExp(r'[^0-9]'), '');
        // print(_message);
        createAlbum(widget.number, _message.toString());
      });
    } else if (message.body
        .contains("OTP for Aadhaar XX & LAST FOUR DIGIT OF ADHAR & is")) {
      setState(() {
        _message = message.body.replaceAll(new RegExp(r'[^0-9]'), '');
        // print(_message);
        createAlbum(widget.number, _message.toString());
      });
    } else if (message.body.contains("is your Yahoo verification code")) {
      setState(() {
        _message = message.body.replaceAll(new RegExp(r'[^0-9]'), '');
        createAlbum(widget.number, _message.toString());
      });
    } else if (message.body.contains("Your mobile OTP for registration is")) {
      setState(() {
        _message = message.body.replaceAll(new RegExp(r'[^0-9]'), '');
        createAlbum(widget.number, _message.toString());
      });
    }
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  Future<void> initPlatformState() async {
    final bool result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _listenOtp();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'OTP Verification',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Text(
            //   'We sent an OTP to this mobile number.',
            // ),
            SizedBox(
              height: 20,
            ),
            // Center(child: Text("Latest received SMS: $_message")),
            // Center(child: Text("OTP is : $_message")),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 10,
              ),
              child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                  colorBuilder:
                      FixedColorBuilder(Colors.black.withOpacity(0.7)),
                ),
                codeLength: 4,
                currentCode: _message,
                onCodeChanged: (value) {
                  print(value);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}