
import 'package:femovil/config/banner_app.dart';
import 'package:flutter/material.dart';


class AppBars extends StatelessWidget {

  final String labelText;
  const AppBars({
    super.key,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(170),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50), // Radio del borde redondeado
        ),
        child: GestureDetector(
         
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          
          child: AppBar(
              leading: IconButton(
          icon: Image.asset('lib/assets/Atras@3x.png', width: 25, height: 25,), // Reemplaza 'tu_imagen.png' con la ruta de tu imagen en los assets
          onPressed: () {
            // Acción al presionar el botón de flecha hacia atrás
            Navigator.pop(context);
          },
        ),
            backgroundColor: const Color(0xFF7531FF), // Color hexadecimal
            flexibleSpace: Stack(
              children: [
                CustomPaint(
                  painter: CirclePainter(),
                ),
                 Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 55,),
                      Text(
                        labelText,
                        style: const TextStyle(
                          fontFamily: 'Poppins ExtraBold',
                          color: Colors.white,
                          fontSize: 30, // Tamaño del texto
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 3.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}