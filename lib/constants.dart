import 'package:flutter/material.dart';

const kinputdecor = InputDecoration(
  hintText: 'Enter your email',
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF01B574), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF01B574), width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
const Color kprimColor = Color(0xFF00BE78);
const Widget removeicon = Icon(
  Icons.remove,
  color: Colors.grey,
);
const Widget addicon = Icon(
  Icons.add,
  color: Colors.grey,
);

const Color inactivecolor = Color(0xFFc1c1c1);
const Color activecolor = Color(0xFF00ff99);

const pad = EdgeInsets.all(10);
const buttonmargin = EdgeInsets.only(right: 30);

const double borderradius = 20;
