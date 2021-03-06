import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContainerTextCentered(),
    ),
  );
}

class ContainerTextCentered extends StatelessWidget {
  const ContainerTextCentered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text = '汉字的序顺并不定一能影阅响读';
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.purple,
              alignment: Alignment.center,
              child: Text(text),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text(text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
