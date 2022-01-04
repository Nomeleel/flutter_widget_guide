import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhysicalModelCardShadom(),
    ),
  );
}

class PhysicalModelCardShadom extends StatelessWidget {
  const PhysicalModelCardShadom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = FlutterLogo(
      size: 120.0,
    );
    final BorderRadius borderRadius = BorderRadius.all(Radius.circular(10.0));
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PhysicalModel(
              color: Colors.grey,
              elevation: 10.0,
              shadowColor: Colors.grey[900]!,
              clipBehavior: Clip.hardEdge,
              borderRadius: borderRadius,
              child: child,
            ),
            Card(
              color: Colors.grey,
              elevation: 10.0,
              shadowColor: Colors.grey[900],
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              child: child,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: borderRadius,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(2.0, 8.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
