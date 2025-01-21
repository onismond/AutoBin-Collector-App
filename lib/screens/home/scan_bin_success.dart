import 'package:flutter/material.dart';


class ScanBinSuccess extends StatelessWidget {
  const ScanBinSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Bin Cleared Successfully",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Continue")
              )
            ],
          ),
        ),
      )
    );
  }
}


