import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';

import 'package:flutter/material.dart';

class SearchBarWithProfile extends StatefulWidget {
  const SearchBarWithProfile({super.key});

  @override
  State<SearchBarWithProfile> createState() => _SearchBarWithProfileState();
}

class _SearchBarWithProfileState extends State<SearchBarWithProfile> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Détection de la taille de l'écran pour afficher ou non le profil
    bool isDesktop = MediaQuery.of(context).size.width >=
        600; // Si l'écran est plus large que 1024px, c'est un desktop

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isDesktop
            ? SizedBox(height: 40,
                width: MediaQuery.of(context).size.width / 3,
                child: Card(margin: EdgeInsets.zero,
                  color: Colors.white,
                  elevation: 4,
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Rechercher un signataire...',
                      suffix: searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                });
                              },
                              icon: const Icon(
                                Icons.close_outlined,
                                size: 15,
                              ),
                              style: IconButton.styleFrom(
                                  minimumSize: const Size(2, 2)),
                            ),
                      prefixIcon: const Icon(Icons.search, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16.0),
                      hintStyle: const TextStyle(height: 1.5),
                    ),
                    onChanged: (query) {
                      setState(() {});
                    },
                  ),
                ),
              )
            : Expanded(
                child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              )),
        // Affiche UserProfile seulement si c'est un desktop
        if (isDesktop)
          const Row(
            children: [
              UserProfile(),
            ],
          ),
      ],
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jane Cooper',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(userinfo.authmodel.value.user!.email!,
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
