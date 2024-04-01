import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MapEvent { placeMarker }

// Manuel de Jesús De la Cruz Solano, 2021-1967
class MapBloc extends Bloc<MapEvent, LatLng?> {
  MapBloc() : super(null);

  @override
  Stream<LatLng?> mapEventToState(MapEvent event) async* {
    if (event == MapEvent.placeMarker) {
      yield LatLng(_latitudeFromDataInputScreen, _longitudeFromDataInputScreen);
    }
  }

  double get _latitudeFromDataInputScreen {
    return 0.0;
  }

  double get _longitudeFromDataInputScreen {
    return 0.0;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa',
      home: BlocProvider(
        create: (_) => MapBloc(),
        child: const MapScreen(),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapBloc mapBloc = BlocProvider.of<MapBloc>(context);
    LatLng? markerPosition;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: BlocBuilder<MapBloc, LatLng?>(
        builder: (context, state) {
          markerPosition = state;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: markerPosition ?? LatLng(0, 0),
              zoom: 12,
            ),
            markers: (markerPosition == null)
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('1'),
                      position: markerPosition!,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Detalles del Marcador'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nombre: John'),
                                  Text('Apellido: Doe'),
                                  Text('Ciudad: New York'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic>? data = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataInputScreen()),
          );

          if (data != null) {
            mapBloc.add(MapEvent.placeMarker);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Manuel de Jesús De la Cruz Solano, 2021-1967
class DataInputScreen extends StatefulWidget {
  const DataInputScreen({Key? key}) : super(key: key);

  @override
  _DataInputScreenState createState() => _DataInputScreenState();
}

class _DataInputScreenState extends State<DataInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: const InputDecoration(labelText: 'Latitud'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _longitudeController,
              decoration: const InputDecoration(labelText: 'Longitud'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Obtener los valores ingresados por el usuario
                String name = _nameController.text;
                String lastName = _lastNameController.text;
                double latitude =
                    double.tryParse(_latitudeController.text) ?? 0.0;
                double longitude =
                    double.tryParse(_longitudeController.text) ?? 0.0;

                // Enviar los datos ingresados al Bloc
                Navigator.pop(context, {
                  'name': name,
                  'lastName': lastName,
                  'latitude': latitude,
                  'longitude': longitude,
                });
              },
              child: const Text('Enviar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
// Manuel de Jesús De la Cruz Solano, 2021-1967