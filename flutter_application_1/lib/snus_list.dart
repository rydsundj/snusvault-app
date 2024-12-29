import 'package:cloud_firestore/cloud_firestore.dart';

//used to add the products to firestore but not used locally now. If I want to add more products i can do it here
void addSnusProductsToFirestore() async {
  CollectionReference snusCollection =
      FirebaseFirestore.instance.collection('snus');

  List<Map<String, dynamic>> snusProducts = [
    {
      "name": "General Classic Portion",
      "brand": "General",
      "nicotine_level": "8mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Göteborgs Rape Original",
      "brand": "Göteborgs",
      "nicotine_level": "8mg/g",
      "flavor": "Fruity",
    },
    {
      "name": "Ettan Portion",
      "brand": "Ettan",
      "nicotine_level": "8mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Siberia -80 White Dry",
      "brand": "Siberia",
      "nicotine_level": "43mg/g",
      "flavor": "Mint",
    },
    {
      "name": "General White Portion",
      "brand": "General",
      "nicotine_level": "8mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Oden’s Cold Extreme White Dry",
      "brand": "Oden's",
      "nicotine_level": "22mg/g",
      "flavor": "Mint",
    },
    {
      "name": "Göteborgs Rape White Large",
      "brand": "Göteborgs",
      "nicotine_level": "8mg/g",
      "flavor": "Fruity",
    },
    {
      "name": "General Mint White Portion",
      "brand": "General",
      "nicotine_level": "12mg/g",
      "flavor": "Mint",
    },
    {
      "name": "Knox Original Portion",
      "brand": "Knox",
      "nicotine_level": "10mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "LD Original Portion",
      "brand": "LD",
      "nicotine_level": "10mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Skruf Slim Fresh White",
      "brand": "Skruf",
      "nicotine_level": "12mg/g",
      "flavor": "Mint",
    },
    {
      "name": "Kronan Original Portion",
      "brand": "Kronan",
      "nicotine_level": "10mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Thunder Frosted Portion",
      "brand": "Thunder",
      "nicotine_level": "16mg/g",
      "flavor": "Mint",
    },
    {
      "name": "Röda Lacket Original",
      "brand": "Röda Lacket",
      "nicotine_level": "8mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Granite Original Portion",
      "brand": "Granite",
      "nicotine_level": "9mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Göteborgs Prima Fint",
      "brand": "Göteborgs",
      "nicotine_level": "7mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Skruf Super White Slim Fresh",
      "brand": "Skruf",
      "nicotine_level": "18mg/g",
      "flavor": "Mint",
    },
    {
      "name": "Granit White Portion",
      "brand": "Granit",
      "nicotine_level": "9mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Kaliber Original Portion",
      "brand": "Kaliber",
      "nicotine_level": "9mg/g",
      "flavor": "Tobacco",
    },
    {
      "name": "Oden's Original Extreme Portion",
      "brand": "Oden's",
      "nicotine_level": "22mg/g",
      "flavor": "Tobacco",
    }
  ];

  for (var product in snusProducts) {
    await snusCollection.add(product);
  }
}
