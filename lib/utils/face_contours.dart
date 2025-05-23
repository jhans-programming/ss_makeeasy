import 'package:flutter/material.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';

enum FacePart {
  LeftEyebrow,
  RightEyebrow,
  LeftTopEyelid,
  RightTopEyelid,
  LeftBottomEyelid,
  RightBottomEyelid,
  LeftCheek,
  RightCheek,
  LeftContour,
  RightContour,
  UpperLip,
  BottomLip,
}

Map<FacePart, List<Tuple2<List<int>, Color>>> getFacePartColors(
  Map<FacePart, MaterialColor> facePartColors,
  MakeupCategory selectedCategory,
) {
  MaterialColor leftEyebrowColor = facePartColors[FacePart.LeftEyebrow]!;
  MaterialColor rightEyebrowColor = facePartColors[FacePart.RightEyebrow]!;
  MaterialColor leftTopEyelidColor = facePartColors[FacePart.LeftTopEyelid]!;
  MaterialColor rightTopEyelidColor = facePartColors[FacePart.RightTopEyelid]!;
  MaterialColor leftBottomEyelidColor =
      facePartColors[FacePart.LeftBottomEyelid]!;
  MaterialColor rightBottomEyelidColor =
      facePartColors[FacePart.RightBottomEyelid]!;
  MaterialColor leftCheekColor = facePartColors[FacePart.LeftCheek]!;
  MaterialColor rightCheekColor = facePartColors[FacePart.RightCheek]!;
  MaterialColor leftContourColor = facePartColors[FacePart.LeftContour]!;
  MaterialColor rightContourColor = facePartColors[FacePart.RightContour]!;
  MaterialColor upperLipColor = facePartColors[FacePart.UpperLip]!;
  MaterialColor bottomLipColor = facePartColors[FacePart.BottomLip]!;

  return {
    FacePart.LeftEyebrow: [
      // Left to Right
      // shade 400 ke atas makin terang
      // shade 500 ke bawah makin gelap
      Tuple2([300, 283, 293], leftEyebrowColor.withAlpha(120)), // 0 --> 255
      //Tuple2([293, 283, 276], leftEyebrowColor.withAlpha(120)),
      // Tuple2(
      //   [293, 283, 334],
      //   leftEyebrowColor.withAlpha(
      //     selectedCategory == MakeupCategory.Category1 ? 0 : 120,
      //   ),
      // ),
      Tuple2([293, 283, 334], leftEyebrowColor.withAlpha(120)),
      Tuple2([334, 282, 283], leftEyebrowColor.withAlpha(120)),
      Tuple2([334, 282, 296], leftEyebrowColor.withAlpha(120)),
      Tuple2([296, 295, 282], leftEyebrowColor.withAlpha(120)),
      Tuple2([296, 295, 336], leftEyebrowColor.withAlpha(120)),
      Tuple2([336, 285, 295], leftEyebrowColor.withAlpha(120)),
    ],
    FacePart.RightEyebrow: [
      // Right to Left
      //Tuple2([46, 70, 63], rightEyebrowColor.withAlpha(120)),
      Tuple2([63, 53, 70], rightEyebrowColor.withAlpha(120)),
      Tuple2([63, 53, 105], rightEyebrowColor.withAlpha(120)),
      Tuple2([105, 52, 53], rightEyebrowColor.withAlpha(120)),
      Tuple2([105, 52, 66], rightEyebrowColor.withAlpha(120)),
      Tuple2([66, 65, 52], rightEyebrowColor.withAlpha(120)),
      Tuple2([66, 65, 107], rightEyebrowColor.withAlpha(120)),
      Tuple2([107, 55, 65], rightEyebrowColor.withAlpha(120)),
    ],
    FacePart.LeftTopEyelid: [
      //Makeup Category 1
      // Left to Right
      Tuple2(
        [446, 467, 359],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [359, 263, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [263, 466, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [466, 388, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [467, 260, 388],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [388, 387, 260],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [260, 259, 387],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [387, 386, 259],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [259, 257, 386],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [257, 258, 386],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [386, 385, 258],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [258, 286, 385],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [385, 384, 286],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [286, 414, 384],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [384, 398, 414],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [398, 463, 414],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),

      //Makeup Category 2
      //eyeliner
      Tuple2(
        [353, 446, 359],
        leftTopEyelidColor.shade900.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 120 : 0,
        ),
      ),
      //eyeshadow
      Tuple2(
        [446, 467, 353],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [260, 467, 353],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),

      Tuple2(
        [446, 467, 359],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [359, 263, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [263, 466, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [466, 388, 467],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [467, 260, 388],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [388, 387, 260],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [260, 259, 387],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [387, 386, 259],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [259, 257, 386],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [257, 258, 386],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [386, 385, 258],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [258, 286, 385],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [385, 384, 286],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [286, 384, 398],
        leftTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
    ],
    FacePart.RightTopEyelid: [
      // Right to Left
      Tuple2(
        [130, 226, 247],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [33, 130, 247],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [246, 33, 247],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [161, 246, 247],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [30, 247, 161],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [160, 161, 30],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [29, 30, 160],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [159, 160, 29],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [27, 29, 159],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [28, 27, 159],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [158, 159, 28],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [56, 28, 158],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [157, 158, 56],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [190, 56, 157],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [173, 157, 190],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [243, 173, 190],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),

      //Makeup Category 2
      //eyeliner
      Tuple2(
        [130, 124, 226],
        rightTopEyelidColor.shade900.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 120 : 0,
        ),
      ),

      //eyeshadow
      Tuple2(
        [130, 124, 30],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      // Tuple2(
      //   [33, 130, 247],
      //   rightTopEyelidColor.withAlpha(
      //     selectedCategory == MakeupCategory.Category2 ? 70 : 0,
      //   ),
      // ),
      // Tuple2(
      //   [246, 33, 247],
      //   rightTopEyelidColor.withAlpha(
      //     selectedCategory == MakeupCategory.Category2 ? 70 : 0,
      //   ),
      // ),
      // Tuple2(
      //   [161, 246, 247],
      //   rightTopEyelidColor.withAlpha(
      //     selectedCategory == MakeupCategory.Category2 ? 70 : 0,
      //   ),
      // ),
      Tuple2(
        [30, 130, 161],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [160, 161, 30],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [29, 30, 160],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [159, 160, 29],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [27, 29, 159],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [28, 27, 159],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [158, 159, 28],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [56, 28, 158],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
      Tuple2(
        [155, 56, 158],
        rightTopEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category2 ? 70 : 0,
        ),
      ),
    ],
    FacePart.LeftBottomEyelid: [
      // Left to Right

      // Upper
      Tuple2(
        [446, 359, 255],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [359, 263, 255],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [263, 249, 255],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [255, 339, 249],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [249, 390, 339],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [390, 373, 339],
        leftBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2([339, 254, 373], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([254, 253, 373], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([373, 374, 253], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([374, 380, 253], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([253, 252, 380], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([380, 381, 252], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([252, 256, 381], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([381, 382, 256], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([256, 341, 382], leftBottomEyelidColor.withAlpha(0)),
      Tuple2([382, 362, 341], leftBottomEyelidColor.withAlpha(0)),

      // Lower =>taken as part of left cheek
      // Tuple2([446, 255, 261], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([261, 448, 255], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([255, 339, 448], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([448, 449, 339], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([339, 254, 449], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([449, 450, 254], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([254, 253, 450], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([450, 451, 253], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([253, 252, 451], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([451, 452, 252], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([252, 256, 452], leftBottomEyelidColor.withAlpha(0)),
      // Tuple2([256, 341, 452], leftBottomEyelidColor.withAlpha(0)),
    ],
    FacePart.RightBottomEyelid: [
      //Right to Left

      // Upper
      Tuple2(
        [130, 226, 25],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [33, 130, 25],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [7, 33, 25],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [110, 25, 7],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [163, 7, 110],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2(
        [144, 163, 110],
        rightBottomEyelidColor.withAlpha(
          selectedCategory == MakeupCategory.Category1 ? 70 : 0,
        ),
      ),
      Tuple2([24, 110, 144], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([23, 24, 144], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([145, 144, 23], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([153, 145, 23], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([22, 23, 153], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([154, 153, 22], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([26, 22, 154], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([155, 154, 26], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([112, 26, 155], rightBottomEyelidColor.withAlpha(0)),
      Tuple2([133, 155, 112], rightBottomEyelidColor.withAlpha(0)),

      // Lower taken as upper right cheek
      // Tuple2([25, 226, 31], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([228, 31, 25], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([110, 25, 228], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([229, 228, 110], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([24, 110, 229], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([230, 229, 24], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([23, 24, 230], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([231, 230, 23], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([22, 23, 231], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([232, 231, 22], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([26, 22, 232], rightBottomEyelidColor.withAlpha(120)),
      // Tuple2([112, 26, 232], rightBottomEyelidColor.withAlpha(120)),
    ],
    FacePart.LeftCheek: [
      // Top to Bottom
      // Right to Left
      // Center part
      //below eye
      Tuple2([264, 368, 446], leftCheekColor.withAlpha(20)),
      Tuple2([264, 372, 265], leftCheekColor.withAlpha(20)),
      Tuple2([264, 446, 265], leftCheekColor.withAlpha(20)),
      Tuple2([261, 446, 265], leftCheekColor.withAlpha(20)),
      Tuple2([446, 255, 261], leftCheekColor.withAlpha(20)),
      Tuple2([261, 448, 255], leftCheekColor.withAlpha(20)),
      Tuple2([255, 339, 448], leftCheekColor.withAlpha(20)),
      Tuple2([448, 449, 339], leftCheekColor.withAlpha(20)),
      Tuple2([339, 254, 449], leftCheekColor.withAlpha(20)),
      Tuple2([449, 450, 254], leftCheekColor.withAlpha(20)),
      Tuple2([254, 253, 450], leftCheekColor.withAlpha(20)),
      Tuple2([450, 451, 253], leftCheekColor.withAlpha(20)),
      Tuple2([253, 252, 451], leftCheekColor.withAlpha(20)),
      Tuple2([451, 452, 252], leftCheekColor.withAlpha(20)),
      Tuple2([252, 256, 452], leftCheekColor.withAlpha(20)),
      Tuple2([256, 341, 452], leftCheekColor.withAlpha(20)),
      //center cheek
      Tuple2([347, 348, 449], leftCheekColor.withAlpha(20)),
      Tuple2([448, 449, 347], leftCheekColor.withAlpha(20)),
      Tuple2([346, 347, 448], leftCheekColor.withAlpha(20)),
      Tuple2([340, 346, 448], leftCheekColor.withAlpha(20)),
      Tuple2([345, 346, 340], leftCheekColor.withAlpha(20)),
      /////////////////////////////////////////////////////////////////
      Tuple2([347, 348, 330], leftCheekColor.withAlpha(20)),
      Tuple2([280, 330, 347], leftCheekColor.withAlpha(20)),
      Tuple2([346, 347, 280], leftCheekColor.withAlpha(20)),
      Tuple2([352, 280, 346], leftCheekColor.withAlpha(20)),
      Tuple2([345, 346, 352], leftCheekColor.withAlpha(20)),
      Tuple2([366, 352, 345], leftCheekColor.withAlpha(20)),
      /////////////////////////////////////////////////////////////////
      Tuple2([425, 266, 330], leftCheekColor.withAlpha(20)),
      Tuple2([280, 330, 425], leftCheekColor.withAlpha(20)),
      Tuple2([411, 425, 280], leftCheekColor.withAlpha(20)),
      Tuple2([352, 280, 411], leftCheekColor.withAlpha(20)),
      Tuple2([376, 411, 352], leftCheekColor.withAlpha(20)),
      Tuple2([366, 352, 376], leftCheekColor.withAlpha(20)),
      Tuple2([401, 376, 366], leftCheekColor.withAlpha(0)), //leftsiderounded
      ////////////////////////////////////////////////////////////////
      Tuple2([425, 266, 426], leftCheekColor.withAlpha(0)),
      Tuple2([427, 426, 425], leftCheekColor.withAlpha(0)),
      Tuple2([411, 427, 425], leftCheekColor.withAlpha(0)),
      Tuple2([411, 427, 416], leftCheekColor.withAlpha(0)),
      Tuple2([376, 411, 416], leftCheekColor.withAlpha(0)),
      Tuple2([376, 433, 416], leftCheekColor.withAlpha(0)),
      Tuple2([401, 376, 433], leftCheekColor.withAlpha(0)),
      Tuple2([435, 433, 401], leftCheekColor.withAlpha(0)),
      ////////////////////////////////////////////////////////////////
      Tuple2([427, 436, 426], leftCheekColor.withAlpha(0)),
      Tuple2([427, 436, 434], leftCheekColor.withAlpha(0)),
      Tuple2([416, 434, 427], leftCheekColor.withAlpha(0)),
      Tuple2([435, 434, 416], leftCheekColor.withAlpha(0)),
      Tuple2([435, 416, 433], leftCheekColor.withAlpha(0)),

      // Left-most part (Right to Left)
      Tuple2([340, 448, 261], leftCheekColor.withAlpha(20)),
      Tuple2([340, 261, 265], leftCheekColor.withAlpha(20)),
      Tuple2([372, 265, 340], leftCheekColor.withAlpha(20)),
      Tuple2([345, 340, 372], leftCheekColor.withAlpha(20)),
      Tuple2([264, 372, 345], leftCheekColor.withAlpha(20)),
      Tuple2([447, 345, 264], leftCheekColor.withAlpha(20)),
      Tuple2([447, 345, 366], leftCheekColor.withAlpha(20)),

      // Right-most part (Top to bottom, Right to left)
      Tuple2([451, 350, 452], leftCheekColor.withAlpha(20)),
      Tuple2([349, 350, 451], leftCheekColor.withAlpha(20)),
      Tuple2([450, 451, 349], leftCheekColor.withAlpha(20)),
      Tuple2([348, 349, 450], leftCheekColor.withAlpha(20)),
      Tuple2([449, 450, 348], leftCheekColor.withAlpha(20)),
      ////////////////////////////////////////////////////////////////
      Tuple2([349, 277, 350], leftCheekColor.withAlpha(20)),
      Tuple2([329, 277, 349], leftCheekColor.withAlpha(20)),
      Tuple2([348, 349, 329], leftCheekColor.withAlpha(20)),
      Tuple2([330, 329, 348], leftCheekColor.withAlpha(20)),
      /////////////////////////////////////////////////////////////////
      Tuple2([329, 277, 371], leftCheekColor.withAlpha(20)),
      Tuple2([266, 371, 329], leftCheekColor.withAlpha(20)),
      Tuple2([330, 329, 266], leftCheekColor.withAlpha(20)),
      ////////////////////////////////////////////////////////////////
      Tuple2([266, 371, 426], leftCheekColor.withAlpha(0)),

      //extra left part
      Tuple2([389, 264, 368], rightCheekColor.withAlpha(20)),
      Tuple2([389, 264, 356], rightCheekColor.withAlpha(20)),
      Tuple2([447, 264, 356], rightCheekColor.withAlpha(20)),
      Tuple2([447, 356, 454], rightCheekColor.withAlpha(20)),
      Tuple2([454, 366, 447], rightCheekColor.withAlpha(20)),
    ],
    FacePart.RightCheek: [
      //upper right cheek from eye
      Tuple2([35, 226, 162], rightCheekColor.withAlpha(20)),
      Tuple2([35, 34, 162], rightCheekColor.withAlpha(20)),
      Tuple2([35, 34, 143], rightCheekColor.withAlpha(20)),
      Tuple2([35, 226, 31], rightCheekColor.withAlpha(20)),
      Tuple2([34, 227, 162], rightCheekColor.withAlpha(20)),
      Tuple2([25, 226, 31], rightCheekColor.withAlpha(20)),
      Tuple2([228, 31, 25], rightCheekColor.withAlpha(20)),
      Tuple2([110, 25, 228], rightCheekColor.withAlpha(20)),
      Tuple2([229, 228, 110], rightCheekColor.withAlpha(20)),
      Tuple2([24, 110, 229], rightCheekColor.withAlpha(20)),
      Tuple2([230, 229, 24], rightCheekColor.withAlpha(20)),
      Tuple2([23, 24, 230], rightCheekColor.withAlpha(20)),
      Tuple2([231, 230, 23], rightCheekColor.withAlpha(20)),
      Tuple2([22, 23, 231], rightCheekColor.withAlpha(20)),
      Tuple2([232, 231, 22], rightCheekColor.withAlpha(20)),
      Tuple2([26, 22, 232], rightCheekColor.withAlpha(20)),
      Tuple2([112, 26, 232], rightCheekColor.withAlpha(20)),
      //lower right cheek

      // Top to Bottom
      // Left to Right
      // Center part
      Tuple2([101, 119, 229], rightCheekColor.withAlpha(20)),
      Tuple2([101, 118, 229], rightCheekColor.withAlpha(20)),
      Tuple2([118, 117, 229], rightCheekColor.withAlpha(20)),
      Tuple2([117, 228, 229], rightCheekColor.withAlpha(20)),
      Tuple2([117, 111, 228], rightCheekColor.withAlpha(20)),
      Tuple2([117, 116, 111], rightCheekColor.withAlpha(20)),
      ///////////////////////////////////////////////////////////////
      //bagian tengah bawah
      Tuple2([206, 205, 36], rightCheekColor.withAlpha(0)),
      Tuple2([36, 101, 205], rightCheekColor.withAlpha(20)),
      Tuple2([205, 50, 101], rightCheekColor.withAlpha(20)),
      Tuple2([101, 118, 50], rightCheekColor.withAlpha(20)),
      Tuple2([118, 117, 50], rightCheekColor.withAlpha(20)),
      Tuple2([50, 123, 117], rightCheekColor.withAlpha(20)),
      Tuple2([117, 116, 123], rightCheekColor.withAlpha(20)),
      Tuple2([123, 137, 116], rightCheekColor.withAlpha(20)),
      ///////////////////////////////////////////////////////////////
      //lower right cheek
      Tuple2([216, 207, 206], rightCheekColor.withAlpha(0)),
      Tuple2([206, 205, 207], rightCheekColor.withAlpha(0)),
      Tuple2([207, 187, 205], rightCheekColor.withAlpha(0)),
      Tuple2([205, 50, 187], rightCheekColor.withAlpha(20)),
      Tuple2([50, 123, 187], rightCheekColor.withAlpha(20)),
      Tuple2([187, 147, 123], rightCheekColor.withAlpha(20)),
      Tuple2([123, 137, 147], rightCheekColor.withAlpha(20)),
      Tuple2([147, 177, 137], rightCheekColor.withAlpha(0)),
      ///////////////////////////////////////////////////////////////
      Tuple2([216, 207, 214], rightCheekColor.withAlpha(0)),
      Tuple2([214, 192, 207], rightCheekColor.withAlpha(0)),
      Tuple2([207, 187, 192], rightCheekColor.withAlpha(0)),
      Tuple2([187, 147, 192], rightCheekColor.withAlpha(0)),
      Tuple2([192, 213, 147], rightCheekColor.withAlpha(0)),
      Tuple2([213, 177, 147], rightCheekColor.withAlpha(0)),
      ///////////////////////////////////////////////////////////////
      Tuple2([214, 215, 192], rightCheekColor.withAlpha(0)),
      Tuple2([192, 215, 213], rightCheekColor.withAlpha(0)),
      Tuple2([213, 215, 177], rightCheekColor.withAlpha(0)),

      // Right-most part (Left to Right)
      Tuple2([228, 111, 31], rightCheekColor.withAlpha(20)),
      Tuple2([31, 111, 35], rightCheekColor.withAlpha(20)),
      Tuple2([35, 143, 111], rightCheekColor.withAlpha(20)),
      Tuple2([111, 116, 143], rightCheekColor.withAlpha(20)),
      Tuple2([143, 34, 116], rightCheekColor.withAlpha(20)),
      Tuple2([116, 227, 34], rightCheekColor.withAlpha(20)),
      Tuple2([116, 227, 137], rightCheekColor.withAlpha(20)),

      // Left-most part (Top to Bottom, Left to Right)
      Tuple2([232, 231, 121], rightCheekColor.withAlpha(20)),
      Tuple2([121, 120, 231], rightCheekColor.withAlpha(20)),
      Tuple2([231, 230, 120], rightCheekColor.withAlpha(20)),
      Tuple2([120, 119, 230], rightCheekColor.withAlpha(20)),
      Tuple2([230, 229, 119], rightCheekColor.withAlpha(20)),
      //////////////////////////////////////////////////////////////////
      Tuple2([121, 120, 47], rightCheekColor.withAlpha(20)),
      Tuple2([47, 100, 120], rightCheekColor.withAlpha(20)),
      Tuple2([120, 119, 100], rightCheekColor.withAlpha(20)),
      Tuple2([100, 101, 119], rightCheekColor.withAlpha(20)),
      /////////////////////////////////////////////////////////////////
      //rounded part kiri
      Tuple2([47, 100, 142], rightCheekColor.withAlpha(20)),
      Tuple2([142, 36, 100], rightCheekColor.withAlpha(20)),
      Tuple2([100, 101, 36], rightCheekColor.withAlpha(20)),
      Tuple2([142, 36, 206], rightCheekColor.withAlpha(0)),

      //extra right part
      Tuple2([227, 127, 162], rightCheekColor.withAlpha(20)),
      Tuple2([234, 127, 227], rightCheekColor.withAlpha(20)),
      Tuple2([234, 137, 227], rightCheekColor.withAlpha(20)),
      //Tuple2([234, 137, 93], rightCheekColor.withAlpha(20)),
      Tuple2([147, 137, 93], rightCheekColor.withAlpha(20)),
    ],
    FacePart.LeftContour: [
      //top to bottom
      // Left to Right
      Tuple2([433, 376, 454], leftContourColor.withAlpha(40)),
      Tuple2([433, 323, 454], leftContourColor.withAlpha(40)),
      Tuple2([433, 323, 401], leftContourColor.withAlpha(40)),
      Tuple2([361, 323, 401], leftContourColor.withAlpha(40)),
      Tuple2([361, 433, 401], leftContourColor.withAlpha(40)),
      Tuple2([376, 433, 401], leftContourColor.withAlpha(40)),
    ],
    FacePart.RightContour: [
      //top to bottom
      // Right to Left
      Tuple2([147, 234, 93], rightContourColor.withAlpha(60)),
      Tuple2([177, 132, 93], rightContourColor.withAlpha(60)),
      Tuple2([177, 132, 213], rightContourColor.withAlpha(60)),
      Tuple2([147, 177, 213], rightContourColor.withAlpha(60)),
      Tuple2([147, 177, 93], rightContourColor.withAlpha(60)),
    ],
    FacePart.UpperLip: [
      // Top to Bottom (4 layers)
      // Left to Right

      /**
   * 0 -------- 1
   * |          |
   * |          |
   * 3 -------- 2
   */
      Tuple2([409, 408, 306], upperLipColor.withAlpha(50)),
      Tuple2([409, 270, 304, 408], upperLipColor.withAlpha(50)),
      Tuple2([270, 269, 303, 304], upperLipColor.withAlpha(50)),
      Tuple2([269, 267, 302, 303], upperLipColor.withAlpha(50)),
      Tuple2([267, 0, 11, 302], upperLipColor.withAlpha(50)),
      Tuple2([0, 37, 72, 11], upperLipColor.withAlpha(50)),
      Tuple2([37, 39, 73, 72], upperLipColor.withAlpha(50)),
      Tuple2([39, 40, 74, 73], upperLipColor.withAlpha(50)),
      Tuple2([40, 185, 184, 74], upperLipColor.withAlpha(50)),
      Tuple2([185, 184, 76], upperLipColor.withAlpha(50)),
      ////////////////////////////////////////////////////////////
      Tuple2([306, 408, 407, 308], upperLipColor.withAlpha(70)),
      Tuple2([408, 304, 272, 407], upperLipColor.withAlpha(70)),
      Tuple2([304, 303, 271, 272], upperLipColor.withAlpha(70)),
      Tuple2([303, 302, 268, 271], upperLipColor.withAlpha(70)),
      Tuple2([302, 11, 12, 268], upperLipColor.withAlpha(70)),
      Tuple2([11, 72, 38, 12], upperLipColor.withAlpha(70)),
      Tuple2([72, 73, 41, 38], upperLipColor.withAlpha(70)),
      Tuple2([73, 74, 42, 41], upperLipColor.withAlpha(70)),
      Tuple2([74, 184, 183, 42], upperLipColor.withAlpha(70)),
      Tuple2([184, 76, 78, 183], upperLipColor.withAlpha(70)),
      //////////////////////////////////////////////////////////////
      Tuple2([407, 415, 308], upperLipColor.withAlpha(70)),
      Tuple2([407, 272, 310, 415], upperLipColor.withAlpha(70)),
      Tuple2([272, 271, 311, 310], upperLipColor.withAlpha(70)),
      Tuple2([271, 268, 312, 311], upperLipColor.withAlpha(70)),
      Tuple2([268, 12, 13, 312], upperLipColor.withAlpha(70)),
      Tuple2([12, 38, 82, 13], upperLipColor.withAlpha(70)),
      Tuple2([38, 41, 81, 82], upperLipColor.withAlpha(70)),
      Tuple2([41, 42, 80, 81], upperLipColor.withAlpha(70)),
      Tuple2([42, 183, 191, 80], upperLipColor.withAlpha(70)),
      Tuple2([191, 183, 78], upperLipColor.withAlpha(70)),
    ],
    FacePart.BottomLip: [
      // Top to Bottom (4 layers)
      // Left to Right

      /**
   * 0 -------- 1
   * |          |
   * |          |
   * 3 -------- 2
   */
      Tuple2([308, 324, 325], bottomLipColor.withAlpha(60)),
      Tuple2([324, 318, 319, 325], bottomLipColor.withAlpha(60)),
      Tuple2([318, 402, 403, 319], bottomLipColor.withAlpha(60)),
      Tuple2([402, 317, 316, 403], bottomLipColor.withAlpha(60)),
      Tuple2([317, 14, 15, 316], bottomLipColor.withAlpha(60)),
      Tuple2([14, 87, 86, 15], bottomLipColor.withAlpha(60)),
      Tuple2([87, 178, 179, 86], bottomLipColor.withAlpha(60)),
      Tuple2([178, 88, 89, 179], bottomLipColor.withAlpha(60)),
      Tuple2([88, 95, 96, 89], bottomLipColor.withAlpha(60)),
      Tuple2([95, 96, 78], bottomLipColor.withAlpha(60)),
      ////////////////////////////////////////////////////////
      Tuple2([308, 325, 307, 306], bottomLipColor.withAlpha(60)),
      Tuple2([325, 319, 320, 307], bottomLipColor.withAlpha(60)),
      Tuple2([319, 403, 404, 320], bottomLipColor.withAlpha(60)),
      Tuple2([403, 316, 315, 404], bottomLipColor.withAlpha(60)),
      Tuple2([316, 15, 16, 315], bottomLipColor.withAlpha(60)),
      Tuple2([15, 86, 85, 16], bottomLipColor.withAlpha(60)),
      Tuple2([86, 179, 180, 85], bottomLipColor.withAlpha(60)),
      Tuple2([179, 89, 90, 180], bottomLipColor.withAlpha(60)),
      Tuple2([89, 96, 77, 90], bottomLipColor.withAlpha(60)),
      Tuple2([96, 78, 76, 77], bottomLipColor.withAlpha(60)),
      //////////////////////////////////////////////////////////
      Tuple2([306, 307, 375], bottomLipColor.withAlpha(50)),
      Tuple2([307, 320, 321, 375], bottomLipColor.withAlpha(50)),
      Tuple2([320, 404, 405, 321], bottomLipColor.withAlpha(50)),
      Tuple2([404, 315, 314, 405], bottomLipColor.withAlpha(50)),
      Tuple2([315, 16, 17, 314], bottomLipColor.withAlpha(50)),
      Tuple2([16, 85, 84, 17], bottomLipColor.withAlpha(50)),
      Tuple2([85, 180, 181, 84], bottomLipColor.withAlpha(50)),
      Tuple2([180, 90, 91, 181], bottomLipColor.withAlpha(50)),
      Tuple2([90, 77, 146, 91], bottomLipColor.withAlpha(50)),
      Tuple2([77, 76, 146], bottomLipColor.withAlpha(50)),
    ],
  };
}
