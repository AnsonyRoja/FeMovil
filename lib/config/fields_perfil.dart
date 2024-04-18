import 'package:flutter/material.dart';

class Fields extends StatelessWidget {
  final String? value;
  final double heights;
  final String? field;

  const Fields({
    super.key,
    required this.value,
    required this.heights,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start, // Alinea los hijos a la izquierda
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          width: 250,
          
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              '$field ',
              style: const TextStyle(
                color: Color(0xFF7531FF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins SemiBold',
                
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            value!,
            style: const TextStyle(fontSize: 15, fontFamily: 'OpenSans'),
          ),
        ),
        SizedBox(height: heights),
      ],
    );
  }
}
