import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:autobin_collector/utils/screensize.dart';
import '../utils/constants.dart';

// Textbox
final customInput = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.black26),
  fillColor: Colors.white70,
  filled: true,
  contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 0.6),
      borderRadius: BorderRadius.circular(5.0)),
  disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[50]!, width: 0.6),
      borderRadius: BorderRadius.circular(5.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: bShape, width: 1.0),
      borderRadius: BorderRadius.circular(5.0)),
);

// dropdown
final customDropDown = DropdownButton(items: null, onChanged: null);

// custom button class
class CustomButton extends StatelessWidget {
  final double width;
  final double? height;
  final Function onPressed;
  final Widget buttonChild;
  final LinearGradient buttonType;

  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.buttonChild,
    required this.buttonType,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () { onPressed(); },
      style: ElevatedButton.styleFrom(
        foregroundColor: fBright,
        backgroundColor: Colors.blueGrey, // Text color
        elevation: 1.7,
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(13.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: buttonType,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: buttonChild,
      ),
    );

  }
}

class ButtonType {
  final index;

  const ButtonType._(this.index);
  static const defaultButton = LinearGradient(colors: <Color>[gStart, gEnd]);
  static const dangerButton = LinearGradient(colors: <Color>[gDStart, gDEnd]);
  static const successButton = LinearGradient(colors: <Color>[gSStart, gSEnd]);
  static const disabledButton =
      LinearGradient(colors: <Color>[Colors.grey, Colors.grey]);

  static const List<LinearGradient> values = <LinearGradient>[
    defaultButton,
    dangerButton,
    successButton,
    disabledButton
  ];

  @override
  String toString() {
    return const <int, String>{
      0: 'ButtonType.default',
      1: 'ButtonType.danger',
      2: 'ButtonType.success',
      3: 'ButtonType.disabled'
    }[index]!;
  }
}

// Overview Card
class OverViewCard extends StatelessWidget {
  final String vehicleID;
  final int ordersCompleted;
  final String lastPickup;

  const OverViewCard({
    super.key,
    required this.vehicleID,
    required this.ordersCompleted,
    required this.lastPickup,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: <Widget>[
      Container(
        height: screenHeight(context, dividedBy: 4.4),
        width: screenWidth(context, dividedBy: 1.2),
        decoration: BoxDecoration(
            // gradient: LinearGradient(colors: [gStart, gEnd]),
            color: Colors.white.withOpacity(0.99),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  color: cardShadow.withOpacity(0.15)),
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 1,
                  child: Text(
                    "Overview",
                    style: TextStyle(
                        color: fDark,
                        fontSize: 29.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 7.0),
                        RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                style: TextStyle(
                                    color: fDark.withOpacity(0.9),
                                    fontSize: 16),
                                children: [
                                  TextSpan(text: "Vehicle ID: "),
                                  TextSpan(
                                    text: vehicleID,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ])),
                        SizedBox(
                            height: screenHeight(context, dividedBy: 90.0)),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: fDark.withOpacity(0.9),
                                    fontSize: 16),
                                children: [
                              const TextSpan(text: "Completed orders: "),
                              TextSpan(
                                text: ordersCompleted.toString(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ]))
                      ],
                    )),
                SizedBox(height: screenHeight(context, dividedBy: 60.0)),
                const Divider(color: Colors.black26),
                SizedBox(height: screenHeight(context, dividedBy: 70.0)),
                Expanded(
                  flex: 1,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 10, color: fDim.withOpacity(0.7)),
                          children: [
                        TextSpan(text: "Last pickup: "),
                        TextSpan(text: lastPickup)
                      ])),
                )
              ]),
        ),
      )
    ]);
  }
}

// previous Bin card design
class BinCard extends StatelessWidget {
  final String nickName;
  final String binSerial;
  final String binStatus;
  final Function pickupMsg;
  final Function routTo;

  const BinCard({
    super.key,
    required this.nickName,
    required this.binSerial,
    required this.binStatus,
    required this.pickupMsg,
    required this.routTo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 30, right: 10),
        child: Ink(
          height: screenHeight(context, dividedBy: 4.0),
          width: screenWidth(context, dividedBy: 1.6),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [gStart, gEnd]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10), blurRadius: 15, color: cardShadow),
              ]),
          child: InkWell(
            splashColor: Colors.blueGrey,
            borderRadius: BorderRadius.circular(20),
            onTap: () {routTo();},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 30, 18, 15),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style:
                                        TextStyle(color: fBright, fontSize: 16),
                                    children: [
                                  TextSpan(text: "Nickname: "),
                                  TextSpan(
                                      text: nickName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ])),
                            SizedBox(
                                height: screenHeight(context, dividedBy: 50.0)),
                            RichText(
                                text: TextSpan(
                                    style:
                                        TextStyle(color: fBright, fontSize: 17),
                                    children: [
                                  TextSpan(text: "Serial no: "),
                                  TextSpan(
                                      text: binSerial,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight(context, dividedBy: 60.0)),
                    Divider(color: fBright),
                    SizedBox(height: screenHeight(context, dividedBy: 80.0)),
                    Expanded(
                      flex: 1,
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: 17),
                              children: [
                            TextSpan(text: "Status: "),
                            TextSpan(
                                text: binStatus,
                                style: TextStyle(
                                    color: binStatus == "Active"
                                        ? Colors.lightGreenAccent
                                        : redF))
                          ])),
                    )
                  ]),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -18.0,
        right: -17.0,
        child: ElevatedButton(
          onPressed: () {pickupMsg;},
          style: ElevatedButton.styleFrom(
            elevation: 1.0, backgroundColor: Colors.white,
            shape: const CircleBorder(), // Background color for the button
            padding: EdgeInsets.all(0), // Ensure no additional padding affects the shape
          ),
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.white, // Matches the button's background color
            ),
            child: Image.asset('assets/images/Garbage Truck_24px.png'),
          ),
        ),
      ),
    ]);
  }
}

// current Bin Card design
class BinListCard extends StatelessWidget {
  final binID;
  final String nickName;
  final String binSerial;
  final Function pickupMsg;
  final Function routTo;

  const BinListCard({
    super.key,
    this.binID,
    required this.nickName,
    required this.binSerial,
    required this.pickupMsg,
    required this.routTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenHeight(context, dividedBy: 9.0),
        width: screenWidth(context, dividedBy: 1.2),
        margin: EdgeInsets.only(left: 30, bottom: 25, right: 30),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 13,
                    color: cardShadow.withOpacity(0.1)),
              ]),
          child: InkWell(
            splashColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            onTap: () {routTo();},
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: fDark, fontSize: 17),
                                        children: [
                                          TextSpan(text: "Nickname: "),
                                          TextSpan(
                                              text: nickName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                SizedBox(height: 5.5),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: fDark, fontSize: 17),
                                        children: [
                                      TextSpan(text: "Serial no: "),
                                      TextSpan(
                                          text: binSerial,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ])),
                              ]),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            width: screenWidth(context, dividedBy: 8.0),
                            height: screenWidth(context, dividedBy: 6.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 9),
                                      blurRadius: 10,
                                      color: cardShadow.withOpacity(0.15))
                                ],
                                gradient: LinearGradient(
                                    colors: [gNext.withAlpha(180), gNext],
                                    stops: [0.5, 1],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: ElevatedButton(
                              onPressed: () {pickupMsg;},
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0, // Removes button shadow
                                backgroundColor: Colors.transparent, // Transparent button background
                                padding: EdgeInsets.all(15.0), // Button padding
                                shadowColor: Colors.transparent, // Ensures no shadow color appears
                              ),
                              child: Container(
                                child: Image.asset(
                                  'assets/images/Garbage Truck_24px.png',
                                  color: Colors.white, // Keeps the image color as white
                                ),
                              ),
                            ),

                          )),
                    ])),
          ),
        ));
  }
}

// Order Card design
class OrderListCard extends StatelessWidget {
  final nickName;
  final requestType;
  final Function pickupMsg;
  final Function routTo;

  const OrderListCard({
    super.key,
    required this.nickName,
    required this.requestType,
    required this.pickupMsg,
    required this.routTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenHeight(context, dividedBy: 9.0),
        width: screenWidth(context, dividedBy: 1.2),
        margin: EdgeInsets.only(left: 30, bottom: 25, right: 30),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 13,
                    color: cardShadow.withOpacity(0.1)),
              ]),
          child: InkWell(
            splashColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            onTap: () {routTo();},
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: fDark, fontSize: 17),
                                        children: [
                                          TextSpan(text: "Nickname: "),
                                          TextSpan(
                                              text: nickName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                SizedBox(height: 5.5),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: fDark, fontSize: 17),
                                        children: [
                                      TextSpan(text: requestType),
                                    ]))
                              ]),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            width: screenWidth(context, dividedBy: 8.0),
                            height: screenWidth(context, dividedBy: 6.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 9),
                                      blurRadius: 10,
                                      color: cardShadow.withOpacity(0.15))
                                ],
                                gradient: LinearGradient(
                                    colors: [gNext.withAlpha(180), gNext],
                                    stops: [0.5, 1],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: ElevatedButton(
                              onPressed: () {pickupMsg();},
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0, // No shadow
                                backgroundColor: Colors.transparent, // Transparent button background
                                shadowColor: Colors.transparent, // No shadow color
                                padding: EdgeInsets.all(15.0), // Button padding
                              ),
                              child: Image.asset(
                                'assets/images/Garbage Truck_24px.png',
                                color: Colors.white, // White color for the image
                              ),
                            ),

                          )),
                    ])),
          ),
        ));
  }
}

// Tab button pressed
class TabButtonPressed extends StatelessWidget {
  final tabIcon;

  TabButtonPressed({super.key, this.tabIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Icon(
        tabIcon,
        size: 28,
        color: gNext.withOpacity(.7),
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300]!,
                offset: Offset(0.0, 1.0),
                blurRadius: 0.0,
                spreadRadius: 1.0),
            const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 3.0),
                blurRadius: 4.0,
                spreadRadius: 2.0),
          ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[100]!,
                Colors.grey[200]!,
                Colors.grey[300]!,
                Colors.grey[400]!,
              ],
              stops: const [
                0.3,
                0.5,
                0.7,
                1.0,
              ])),
    );
  }
}

// Tab button unpressed
class TabButtonUnpressed extends StatelessWidget {
  final tabIcon;

  TabButtonUnpressed({super.key, this.tabIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Icon(
        tabIcon,
        size: 28,
        color: iconColor,
      ),
      decoration: BoxDecoration(
          color: Colors.transparent,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[400]!,
                Colors.grey[300]!,
                Colors.grey[200]!,
                Colors.grey[100]!,
              ],
              stops: [
                0.1,
                0.3,
                0.8,
                1
              ])),
    );
  }
}

// Loading spinner
final loadingSpinner = SpinKitThreeBounce(
  color: bColor2,
  size: 23.0,
);

// Loading spinner
final loadingSpinner2 = SpinKitThreeBounce(
  color: bColor1,
  size: 30.0,
);

// default dialog
defaultDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String primaryButtonText,
  required Function onPrimaryPress,
  String? secondaryButtonText,
  Function? onSecondaryPress,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        buttonPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        backgroundColor: Colors.white.withOpacity(0.99),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Center(
          child: Container(
              alignment: Alignment.center,
              height: 55.0,
              width: screenWidth(context, dividedBy: 1.0),
              decoration: BoxDecoration(
                  color: gStart,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0))),
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
        ),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text(message),
            ),
            Divider(height: 0.0),
          ]),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {onPrimaryPress();},
            child: Text(
              primaryButtonText,
              style: TextStyle(color: gSStart),
            ),
          ),
          if (secondaryButtonText != null) // Use conditional widget inclusion
            TextButton(
              onPressed: () {onSecondaryPress!();},
              child: Text(
                secondaryButtonText,
                style: TextStyle(color: gNext),
              ),
            ),
        ],
      );
    },
  );
}

// Error dialog
errorDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String primaryButtonText,
  required Function onPrimaryPress,
  String? secondaryButtonText,
  Function? onSecondaryPress,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        buttonPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        backgroundColor: Colors.white.withOpacity(0.99),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Center(
          child: Container(
              alignment: Alignment.center,
              height: 55.0,
              width: screenWidth(context, dividedBy: 1.0),
              decoration: BoxDecoration(
                  color: gDStart,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0))),
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
        ),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text(message),
            ),
            Divider(height: 0.0),
          ]),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              primaryButtonText,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {onPrimaryPress();},
          ),
          if (secondaryButtonText != null )
              TextButton(
                  child: Text(
                    secondaryButtonText,
                    style: const TextStyle(
                      color: gNext,
                    ),
                  ),
                  onPressed: () {onPrimaryPress();},
                )
        ],
      );
    },
  );
}

// danger dialog
dangerDialog(
  BuildContext context, {
  required String title,
  required String message,
  required Function onPrimaryPress,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        buttonPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        backgroundColor: Colors.white.withOpacity(0.99),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Center(
          child: Container(
              alignment: Alignment.center,
              height: 55.0,
              width: screenWidth(context, dividedBy: 1.0),
              decoration: BoxDecoration(
                  color: gDStart,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0))),
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
        ),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text(message),
            ),
            Divider(height: 0.0),
          ]),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {onPrimaryPress();},
          ),
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: gNext,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// success dialog
successDialog(BuildContext context, {required String title, required String message}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        buttonPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        backgroundColor: Colors.white.withOpacity(0.99),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Center(
          child: Container(
              alignment: Alignment.center,
              height: 55.0,
              width: screenWidth(context, dividedBy: 1.0),
              decoration: BoxDecoration(
                  color: gSStart,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0))),
              child: Text(
                title,
                style: TextStyle(color: Colors.white),
              )),
        ),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text(message),
            ),
            Divider(height: 0.0),
          ]),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(
                color: gNext,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
