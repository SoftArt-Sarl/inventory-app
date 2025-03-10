import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:get/get.dart';

class SearchBarWithFilter<T> extends StatefulWidget {
  final RxList<T> originalList;
  final RxList<T> filteredList;
  final String hintText;
  final bool isDesktop;
  final bool Function(T, String) filterFunction;

  const SearchBarWithFilter({
    Key? key,
    required this.originalList,
    required this.filteredList,
    required this.filterFunction,
    this.hintText = "Rechercher...",
    this.isDesktop = false,
  }) : super(key: key);

  @override
  _SearchBarWithFilterState<T> createState() => _SearchBarWithFilterState<T>();
}

class _SearchBarWithFilterState<T> extends State<SearchBarWithFilter<T>> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >=
        600;
    return Row(
      children: [
        if(homeController.selectedIndex.value==1||homeController.selectedIndex.value==2)Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(style: IconButton.styleFrom(),onPressed: (
            
          ){homeController.changeIndex(0);}, icon: const Icon(Icons.arrow_back)),
          
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            width: widget.isDesktop ? MediaQuery.of(context).size.width / 2 : double.infinity,
            child: Card(color:Colors.white,
            elevation: 4,
              child: TextFormField(
                controller: searchController,
                focusNode: _searchFocusNode, // Associe le FocusNode
                decoration: InputDecoration(
                  // filled: true,
                  
                  hintText: widget.hintText,
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            widget.filteredList.assignAll(widget.originalList);
                            _searchFocusNode.requestFocus(); // Garde le focus après suppression
                          },
                          icon: const Icon(Icons.close_outlined, size: 15),
                        ),
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
                  hintStyle: const TextStyle(height: 1.5),
                ),
                onChanged: (query) {
                  widget.filteredList.assignAll(
                    widget.originalList.where((item) => widget.filterFunction(item, query)).toList(),
                  );
                      
                  // Réactive le focus après mise à jour
                  Future.delayed(Duration.zero, () {
                    _searchFocusNode.requestFocus();
                  });
                },
              ),
            ),
          ),
        ),
        const Spacer(),
        const UserProfile(),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Jane Cooper',
        //     style: TextStyle(fontWeight: FontWeight.bold)),
        Text(userinfo.authmodel.value.user!.email!,
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}