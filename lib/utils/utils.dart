import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Utils on Widget{
  navigateToNextPage(BuildContext context,Widget widget){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
  }

}