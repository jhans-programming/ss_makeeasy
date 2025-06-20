import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';

import '../utils/coordinates_translator.dart';
import '../utils/face_contours.dart';

class FaceMeshDetectorPainter extends CustomPainter {
  FaceMeshDetectorPainter(
    this.meshes,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.categoryIdx,
  );

  final List<FaceMesh> meshes;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final int categoryIdx;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint lipsPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.pink.withAlpha(80);

    final Paint paint2 =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1.0
          ..color = Colors.white.withAlpha(50);

    final Paint eyebrowPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.purple.withAlpha(80);

    void drawText(Canvas canvas, Offset offset, String text) {
      final textSpan = TextSpan(
        text: text,
        style: const TextStyle(color: Colors.yellow, fontSize: 5),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: double.infinity);

      final offsetPosition = offset + const Offset(2, -10); // Slight offset
      textPainter.paint(canvas, offsetPosition);
    }

    void drawFacePart(List<Tuple2<List<int>, Color>> facePart, FaceMesh mesh) {
      for (final triangle in facePart) {
        Path trianglePath = Path();
        trianglePath.moveTo(
          translateX(
            mesh.points[triangle.item1[0]].x.toDouble(),
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
          translateY(
            mesh.points[triangle.item1[0]].y.toDouble(),
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          ),
        );

        for (int i = 1; i < triangle.item1.length; i++) {
          trianglePath.lineTo(
            translateX(
              mesh.points[triangle.item1[i]].x.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              mesh.points[triangle.item1[i]].y.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
          );
        }

        trianglePath.close();

        Paint p =
            Paint()
              ..style = PaintingStyle.fill
              ..color = triangle.item2;
        canvas.drawPath(trianglePath, p);
      }
    }

    for (final FaceMesh mesh in meshes) {
      // drawLeftEyeBrow();
      // drawRightEyeBrow();
      // drawLowerLip();
      // drawUpperLip();

      // Paint debugPaint =
      //     Paint()
      //       ..color = Colors.orangeAccent
      //       ..strokeCap = StrokeCap.round
      //       ..strokeWidth = 2;
      // List<int> indices = [276, 300, 283, 293, 334, 282, 336, 285];
      // for (int i in indices) {
      //   Offset offset = Offset(
      //     translateX(
      //       mesh.points[i].x,
      //       size,
      //       imageSize,
      //       rotation,
      //       cameraLensDirection,
      //     ),
      //     translateY(
      //       mesh.points[i].y,
      //       size,
      //       imageSize,
      //       rotation,
      //       cameraLensDirection,
      //     ),
      //   );
      //   canvas.drawPoints(PointMode.points, [offset], debugPaint);
      //   drawText(canvas, offset.translate(1, 1), i.toString());
      // }

      MakeupCategory selectedCategory =
          categoryIdx == 0
              ? MakeupCategory.Category1
              : MakeupCategory.Category2;

      Map<FacePart, dynamic> facePartColors = getFacePartColors(
        makeupChoices[selectedCategory]![0],
        selectedCategory,
      );
      //? Eyebrows
      drawFacePart(facePartColors[FacePart.LeftEyebrow], mesh);
      drawFacePart(facePartColors[FacePart.RightEyebrow], mesh);

      //? Top Eyelids
      drawFacePart(facePartColors[FacePart.LeftTopEyelid], mesh);
      drawFacePart(facePartColors[FacePart.RightTopEyelid], mesh);

      //? Bottom Eyelids
      drawFacePart(facePartColors[FacePart.LeftBottomEyelid], mesh);
      drawFacePart(facePartColors[FacePart.RightBottomEyelid], mesh);

      //? Cheeks
      drawFacePart(facePartColors[FacePart.LeftCheek], mesh);
      drawFacePart(facePartColors[FacePart.RightCheek], mesh);

      //? contours
      drawFacePart(facePartColors[FacePart.LeftContour], mesh);
      drawFacePart(facePartColors[FacePart.RightContour], mesh);

      //? Lips
      drawFacePart(facePartColors[FacePart.UpperLip], mesh);
      drawFacePart(facePartColors[FacePart.BottomLip], mesh);
    }
  }

  @override
  bool shouldRepaint(FaceMeshDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.meshes != meshes;
  }
}
