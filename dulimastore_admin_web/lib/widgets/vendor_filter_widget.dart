import 'package:flutter/material.dart';

class VendorFilterWidget extends StatelessWidget {
  const VendorFilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Todos los Vendedores',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Activos',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Inactivos',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Elegidos',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
            ActionChip(
              elevation: 3,
              backgroundColor: Colors.black54,
              label: const Text(
                'Calificacion',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            )




          ],
        ),
      ),
    );
  }
}
