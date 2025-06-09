import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:makeeasy/utils/face_guidelines.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';

import '../utils/coordinates_translator.dart';
import '../utils/face_contours.dart';

class InstructionsPainter extends CustomPainter {
  InstructionsPainter(
    this.meshes,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.config,
  );

  final List<FaceMesh> meshes;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  // [category, step]
  final List<int> config;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..strokeWidth = 2
          ..color = Colors.white;

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

    void drawGuidelines(FaceMesh mesh) {
      List<List<int>> currStepLines =
          guidelineCoordinates[config[0]][config[1]];
      for (List<int> line in currStepLines) {
        List<Offset> points =
            line
                .map(
                  (idx) => Offset(
                    translateX(
                      mesh.points[idx].x.toDouble(),
                      size,
                      imageSize,
                      rotation,
                      cameraLensDirection,
                    ),
                    translateY(
                      mesh.points[idx].y.toDouble(),
                      size,
                      imageSize,
                      rotation,
                      cameraLensDirection,
                    ),
                  ),
                )
                .toList();
        canvas.drawPoints(PointMode.lines, points, paint);
      }
    }

    for (final FaceMesh mesh in meshes) {
      drawGuidelines(mesh);
    }
  }

  @override
  bool shouldRepaint(InstructionsPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.meshes != meshes;
  }
}
