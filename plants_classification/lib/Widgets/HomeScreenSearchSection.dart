import 'package:flutter/material.dart';

class HomeScreenSearchSection extends StatelessWidget{
  const HomeScreenSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
            padding: EdgeInsets.all(25),
            decoration: const BoxDecoration(color: Colors.lightGreen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Plant Lover!",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text("Good Evening!  🌙",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 20,
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(150, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Text(
                        "Search for plants",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

}