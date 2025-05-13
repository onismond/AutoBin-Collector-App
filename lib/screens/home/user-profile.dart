import 'package:flutter/material.dart';
import 'package:autobin_collector/data/services/pref_controller.dart';
import 'package:autobin_collector/utils/constants.dart';
import 'package:autobin_collector/widgets/customWidgets.dart';
import 'package:autobin_collector/utils/input_validations.dart';
import 'package:autobin_collector/utils/screensize.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Form builder key
  final _formKey = GlobalKey<FormState>();

  // Keeps track of the login process
  bool _isProcessing = false;
  bool editingEnabled = false;

  // Form inputs
  String fName = '';
  String lName = '';
  String oName = '';
  String phone = '';
  String email = '';
  String residenceAddress = '';

  initState() {
    super.initState();
    callData();
  }

  callData() async {
    fName = "";
    lName = "";
    oName = "";
    residenceAddress = "";
    phone = "";
    email = "";
    // lName = await PrefController.getLName();
    // oName = await PrefController.getOName();
    // residenceAddress = await PrefController.getRAdress();
    // phone = await PrefController.getPhone();
    // email = await PrefController.getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.grey.withOpacity(.05),
            width: double.infinity,
            height: screenHeight(context, dividedBy: 1.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Profile",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: fDark)),
                        SizedBox(height: 5),
                        Text(
                          'Information you have provided us with. You may modify a few of this data.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  TextFormField(
                                    enabled: false,
                                    decoration: customInput.copyWith(
                                        hintText: '$fName'),
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    decoration: customInput.copyWith(
                                      hintText: '$lName',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    decoration: customInput.copyWith(
                                      hintText: '$oName',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: editingEnabled ? true : false,
                                    onChanged: (value) {
                                      setState(() => phone = value);
                                    },
                                    validator: numOnlyValidation,
                                    decoration: customInput.copyWith(
                                        hintText: 'Vehicle ID'),
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: editingEnabled ? true : false,
                                    onChanged: (value) {
                                      setState(() => phone = value);
                                    },
                                    validator: numOnlyValidation,
                                    decoration: customInput.copyWith(
                                        hintText: '$phone'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: editingEnabled ? true : false,
                                    onChanged: (value) {
                                      setState(() => email = value);
                                    },
                                    validator: emailValidation,
                                    decoration: customInput.copyWith(
                                        hintText: '$email'),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(
                                    height: 12.7,
                                  ),
                                  TextFormField(
                                    enabled: editingEnabled ? true : false,
                                    onChanged: (value) {
                                      setState(() => residenceAddress = value);
                                    },
                                    validator: requiredValidation,
                                    decoration: customInput.copyWith(
                                      hintText: '$residenceAddress',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CustomButton(
                                            width: screenWidth(context,
                                                dividedBy: 2.7),
                                            height: 50.0,
                                            onPressed: editingEnabled
                                                ? () => setState(() {
                                                      editingEnabled = false;
                                                    })
                                                : () => enableEditing(),
                                            buttonChild: Text(
                                                editingEnabled
                                                    ? 'Cancel'
                                                    : 'Edit',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white)),
                                            buttonType: editingEnabled
                                                ? ButtonType.dangerButton
                                                : ButtonType.defaultButton),
                                        CustomButton(
                                            width: screenWidth(context,
                                                dividedBy: 2.8),
                                            height: 50.0,
                                            onPressed: editingEnabled
                                                ? () {
                                                    if (_formKey.currentState
                                                        !.validate()) {
                                                      _submitDataToApi(
                                                          context,
                                                          phone,
                                                          email,
                                                          residenceAddress);
                                                    }
                                                  }
                                                : () {},
                                            buttonChild: _isProcessing
                                                ? loadingSpinner
                                                : Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                            buttonType: editingEnabled
                                                ? ButtonType.successButton
                                                : ButtonType.disabledButton)
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Submits data to api
  void _submitDataToApi(
      BuildContext context, String phone, String email, String rAddress) async {
    // if submission process is already ongoing, exit
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // disable editing after processing is done
    setState(() {
      editingEnabled = false;
    });
  }

  // enable editing (textfields and button states)
  enableEditing() {
    setState(() {
      editingEnabled = true;
    });
  }
}
