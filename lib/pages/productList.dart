import 'package:flutter/material.dart';


class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Solid Lapel Neck Blouse",
      "category": "CLOTHING",
      "sku": "TS38790",
      "variant": "11\nVaries on: Size, Color",
      "price": "\$24",
      "status": "Active",
      "image": "https://storage.googleapis.com/a1aa/image/5uxXRcovgTGqtK8VMr8tMuhxsmAc3_GWaaaoOb4LfhU.jpg",
      "isActive": true
    },
    {
      "name": "Point Toe Heeled Pumps",
      "category": "SHOES",
      "sku": "TS38843",
      "variant": "4\nVaries on: Size",
      "price": "\$56",
      "status": "Out of Stock",
      "image": "https://storage.googleapis.com/a1aa/image/UyBkhnHXETJsQDUKQgcuAjUEIbVD-kvsb4KoebdqHOo.jpg",
      "isActive": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Products"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Export")),
                ElevatedButton(onPressed: () {}, child: Text("New Product")),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(product["image"], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(product["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Category: ${product["category"]}"),
                          Text("SKU: ${product["sku"]}"),
                          Text("Variant: ${product["variant"]}"),
                          Text("Price: ${product["price"]}"),
                        ],
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: product["isActive"] ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product["status"],
                          style: TextStyle(
                            color: product["isActive"] ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
