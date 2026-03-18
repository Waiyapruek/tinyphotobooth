import 'package:flutter/material.dart';

class PrintTemplateModel {
  final String id;
  final String name;
  final String frameAssetPath;   // The frame background/overlay
  final int requiredPhotos;      // How many pictures the camera takes
  final BoxFit fit;              // How the frame should stretch to fit
  final List<Rect> photoHolders; // The X, Y, Width, Height of each picture on the final canvas

  const PrintTemplateModel({
    required this.id,
    required this.name,
    required this.frameAssetPath,
    required this.requiredPhotos,
    this.fit = BoxFit.cover,      // Changed default value to cover to prevent stretching
    required this.photoHolders,
  });
}

// Below are your 3 predefined templates!
// You will need to adjust the Rect.fromLTWH(Left, Top, Width, Height) 
// to match the exact pixel targets for your specific receipt size (e.g. 384px width for 58mm printer)

final List<PrintTemplateModel> appTemplates = [
  PrintTemplateModel(
    id: 'frame1',
    name: '2 Photos Frame',
    frameAssetPath: 'assets/images/frame1.png',
    requiredPhotos: 2,
    photoHolders: [
      const Rect.fromLTWH(60, 220, 264, 198),  // Position for Photo 1
      const Rect.fromLTWH(60, 440, 264, 198), // Position for Photo 2
    ],
  ),
  
  PrintTemplateModel(
    id: 'frame2',
    name: '3 Photos Frame',
    frameAssetPath: 'assets/images/frame2.png',
    requiredPhotos: 3,
    photoHolders: [
      const Rect.fromLTWH(60, 220, 264, 132),  // Photo 1
      const Rect.fromLTWH(60, 360, 264, 132), // Photo 2
      const Rect.fromLTWH(60, 496, 264, 132), // Photo 3
    ],
  ),

  PrintTemplateModel(
    id: 'frame3',
    name: '4 Photos Frame',
    frameAssetPath: 'assets/images/frame3.png',
    requiredPhotos: 4,
    photoHolders: [
      const Rect.fromLTWH(58, 50, 244, 122),  // Photo 1
      const Rect.fromLTWH(58, 190, 244, 122), // Photo 2
      const Rect.fromLTWH(58, 330, 244, 122), // Photo 3
      const Rect.fromLTWH(58, 470, 244, 122), // Photo 4
    ],
  ),
];