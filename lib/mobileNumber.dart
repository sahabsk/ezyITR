import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MobileNUmber extends StatefulWidget {
  @override
  _MobileNUmberState createState() => _MobileNUmberState();
}

class _MobileNUmberState extends State<MobileNUmber> {
  final _formKey = GlobalKey<FormState>();
  var _phoneNumber = '';

  TextEditingController phoneController = TextEditingController();

  void submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // PhoneFieldHint(),
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
            SizedBox(
              height: 26,
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              padding: EdgeInsets.all(18),
              child: TextFormField(
                // key: _formKey,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.start,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  // labelStyle: TextStyle(
                  //   fontSize: 30,
                  // ),
                  counterText: " ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  hintText: 'Mobile Number',
                  hintStyle: TextStyle(
                    fontSize: 20,
                  ),
                  prefixText: "+91 ",
                  prefixStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty || value.length < 10) {
                    return 'Invalid Mobile Number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value;
                  print('+91 $_phoneNumber');
                },
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
              onPressed: submit,
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
        ),
      ),
    );
  }
}
