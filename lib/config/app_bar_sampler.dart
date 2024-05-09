import 'package:flutter/material.dart';

class AppBarSample extends StatelessWidget {
  
  final String label;
  
  const AppBarSample({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('lib/assets/Atras-2.png')),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child:  Text(label, style: const TextStyle(fontFamily: 'Poppins SemiBold', fontSize: 18) , textAlign: TextAlign.center ,)) ,
    );
  }
}
