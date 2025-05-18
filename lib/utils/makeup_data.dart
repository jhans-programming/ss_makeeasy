import 'package:flutter/material.dart';
import 'package:makeeasy/utils/face_contours.dart';

enum MakeupCategory { Category1 }

Map<MakeupCategory, List<Map<FacePart, MaterialColor>>> makeupChoices = {
  MakeupCategory.Category1: [
    {
      //? Eyebrows
      FacePart.LeftEyebrow: Colors.deepOrange,
      FacePart.RightEyebrow: Colors.deepOrange,
      //? Top Eyelids
      FacePart.LeftTopEyelid: Colors.indigo,
      FacePart.RightTopEyelid: Colors.indigo,
      //? Bottom Eyelids
      FacePart.LeftBottomEyelid: Colors.deepPurple,
      FacePart.RightBottomEyelid: Colors.deepPurple,
      //? Cheeks
      FacePart.LeftCheek: Colors.pink,
      FacePart.RightCheek: Colors.pink,
      //? Lips
      FacePart.UpperLip: Colors.red,
      FacePart.BottomLip: Colors.red,
    },
  ],
};
