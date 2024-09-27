import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
 

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
  int cureentIndex = 0 ;
  List<Widget> screens = [

  ];

  Bottomnavbar({super.key});
  void onTap(int index){
    
    cureentIndex = index ;

  }
}

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.screens[widget.cureentIndex],
    );
    
    
  }
}