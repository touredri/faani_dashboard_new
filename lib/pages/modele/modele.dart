import 'dart:typed_data';
import 'package:faani_dashboard/constants/style.dart';
import 'package:faani_dashboard/controllers/modeles_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/tendance_contoller.dart';
import '../../models/modele_modele.dart';
import '../../models/tendence.dart';
import '../../service/categorie.dart';

class ModelePage extends StatefulWidget {
  const ModelePage({super.key});

  @override
  State<ModelePage> createState() => _ModelePageState();
}

class _ModelePageState extends State<ModelePage>
    with SingleTickerProviderStateMixin {
  String? selectedFilter;
  List<Modele> models = [];
  List<Tendance> tendances = [];
  final ModeleController modeleController = Get.put(ModeleController());
  final TendanceController tendanceController = Get.put(TendanceController());
  TextEditingController _detailsController = TextEditingController();
  String imageFile = '';
  var _imageData;
  XFile? _image;
  String? _selectedCategory;

  _pickImages() async {
    // Open the image picker
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // Read the image into memory
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _image = image;
        _imageData = imageData;
      });
    }
  }

  addTendance() async {
    List<Map<String, String>> imageInfo = await uploadImages(_image!);
    Tendance tendence = Tendance(
      id: '',
      details: _detailsController.text,
      categorie: _selectedCategory!,
      image: imageInfo[0]['downloadUrl'] ?? '',
    );
    tendence.addTendance();
  }

  Future<List<Map<String, String>>> uploadImages(XFile image) async {
    List<Map<String, String>> imageInfo = [];
    var data = await image.readAsBytes();
    final ref =
        FirebaseStorage.instance.ref().child('tendance').child(image.name);
    await ref.putData(data);
    final url = await ref.getDownloadURL();
    imageInfo.add({
      'downloadUrl': url,
      'path': ref.fullPath,
    });
    return imageInfo;
  }

  @override
  void initState() {
    super.initState();
    modeleController.fetchModeles();
    tendanceController.fetchTendance();
    models = modeleController.modeles;
    tendances = tendanceController.tendances;
  }

  @override
  Widget build(BuildContext context) {
    print('tendance: ${tendanceController.tendances.length}'); // 0 tendance here ?????
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 200;
    TabController _tabController = TabController(length: 2, vsync: this);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            content: Column(
                              children: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    await _pickImages();
                                    setState(() {});
                                  },
                                  child: const Text('Selectionner image'),
                                ),
                                TextField(
                                  controller: _detailsController,
                                  onChanged: (value) {
                                    // Add your details logic here
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Details',
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 300,
                                  child:
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                    future: getCategories(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final items = snapshot.data!
                                            .map((category) =>
                                                DropdownMenuItem<String>(
                                                  value: category['id'],
                                                  child:
                                                      Text(category['libele']),
                                                ))
                                            .toList();

                                        return DropdownButton<String>(
                                          hint: const Text(
                                              'Selectioner categorie'),
                                          value: _selectedCategory,
                                          items: items,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCategory = value;
                                            });
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: _imageData != null
                                      ? Image.memory(_imageData!)
                                      : Container(
                                          alignment: Alignment.center,
                                          child: const Placeholder(),
                                        ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Ajouter'),
                                onPressed: () async {
                                  // Add your add logic here
                                  await addTendance();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: primaryColor,
                ),
                label: Text('Ajouter',
                    style: TextStyle(color: primaryColor, fontSize: 20)),
              ),
              Wrap(
                spacing: 8.0,
                children: <String>['Tous', 'Tissu', 'Bazin', 'Wax', 'Broderie']
                    .map((String filter) => ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedFilter = selected ? filter : null;
                            });
                          },
                          selectedColor: primaryColor,
                          backgroundColor: Colors.grey,
                          labelStyle: const TextStyle(color: Colors.white),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              indicator: CircleTabIndicator(color: primaryColor, radius: 3),
              tabs: const [
                Tab(
                  text: 'Modeles',
                ),
                Tab(
                  text: 'Tendances',
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                GridView.builder(
                  itemCount: models.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10.0, // Add this line
                    crossAxisSpacing: 10.0, // Add this line
                    childAspectRatio:
                        3 / 5, // Adjust this value to change the cell size
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Image.network(
                                        models[index].fichier[0]!),
                                  ),
                                  Text(models[index].detail!),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Supprimer'),
                                  onPressed: () {
                                    modeleController
                                        .removeModele(models[index].id!);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Image.network(
                        models[index].fichier[0]!,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
                // FutureBuilder<List<Tendance>>(
                //   future: tendanceController.fetchTendance(),
                //   builder: (BuildContext context, AsyncSnapshot<List<Tendance>> snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     } else if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else {
                //       tendances = snapshot.data!;
                //       print('tendance: ${tendances.length}');
                //       // return your widget here
                //     }
                //   },
                // ),
                GridView.builder(
                  itemCount: tendances.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10.0, // Add this line
                    crossAxisSpacing: 10.0, // Add this line
                    childAspectRatio:
                        3 / 5, // Adjust this value to change the cell size
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                children: <Widget>[
                                  Expanded(
                                    child:
                                        Image.network(tendances[index].image),
                                  ),
                                  Text(tendances[index].details!),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Supprimer'),
                                  onPressed: () {
                                    tendanceController
                                        .deleteTendance(tendances[index].id!);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Image.network(
                        tendances[index].image,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter({required Color color, required this.radius})
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
