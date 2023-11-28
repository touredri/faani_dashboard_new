import 'package:cached_network_image/cached_network_image.dart';
import 'package:faani_dashboard/controllers/modeles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MostFavoriteModele extends StatefulWidget {
  const MostFavoriteModele({super.key});

  @override
  State<MostFavoriteModele> createState() => _MostFavoriteModeleState();
}

class _MostFavoriteModeleState extends State<MostFavoriteModele> {
  final ModeleController modeleController = Get.put(ModeleController());

  @override
  void initState() {
    super.initState();
    modeleController.fetchMostFavoriteModele();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount =
        MediaQuery.of(context).size.width ~/ 200; // Adjust 200 to your needs
    return Obx(() {
      if (modeleController.isLoading.value) {
        return CircularProgressIndicator();
      } else {
        return Column(
          children: [
            const Text('Modèles les plus aimés'),
            const SizedBox(height: 15),
            Container(
              height: 300,
              child: GridView.builder(
                itemCount: modeleController.topFiveModele.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1, // Adjust to your needs
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[200],
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: modeleController
                                .topFiveModele[index].fichier[0]!,
                            errorWidget: (context, url, error) {
                              print('Failed to load image: $error');
                              return Text('Failed to load image');
                            },
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}
