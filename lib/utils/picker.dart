/// Depends on
/// ImagePicker: https://pub.dev/packages/image_picker

import 'dart:io';

import 'package:courierone/locale/locales.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

enum PickerSource { CAMERA, GALLERY, ASK }

class Picker {
  final _imagePicker = ImagePicker();

  Future<File> pickVideoFile(
      BuildContext context, PickerSource pickerSource) async {
    if (pickerSource == PickerSource.ASK) {
      PickerSource pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppLocalizations.of(context)
              .getTranslationOf("video_pic_header")),
          content: Text(AppLocalizations.of(context)
              .getTranslationOf("video_pic_subheader")),
          actions: <Widget>[
            MaterialButton(
              child:
                  Text(AppLocalizations.of(context).getTranslationOf("cancel")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, null),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)
                  .getTranslationOf("image_pic_camera")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, PickerSource.CAMERA),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)
                  .getTranslationOf("image_pic_gallery")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, PickerSource.GALLERY),
            ),
          ],
        ),
      );
      return pickerSourceChoice != null
          ? _pickVideo(pickerSourceChoice == PickerSource.CAMERA
              ? ImageSource.camera
              : ImageSource.gallery)
          : null;
    } else {
      return _pickVideo(pickerSource == PickerSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery);
    }
  }

  Future<File> pickImageFile(
      BuildContext context, PickerSource pickerSource) async {
    if (pickerSource == PickerSource.ASK) {
      PickerSource pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppLocalizations.of(context)
              .getTranslationOf("image_pic_header")),
          content: Text(AppLocalizations.of(context)
              .getTranslationOf("image_pic_subheader")),
          actions: <Widget>[
            MaterialButton(
              child:
                  Text(AppLocalizations.of(context).getTranslationOf("cancel")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, null),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)
                  .getTranslationOf("image_pic_camera")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, PickerSource.CAMERA),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)
                  .getTranslationOf("image_pic_gallery")),
              textColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, PickerSource.GALLERY),
            ),
          ],
        ),
      );
      return pickerSourceChoice != null
          ? _pickImage(pickerSourceChoice == PickerSource.CAMERA
              ? ImageSource.camera
              : ImageSource.gallery)
          : null;
    } else {
      return _pickImage(pickerSource == PickerSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery);
    }
  }

  Future<File> _pickImage(ImageSource imageSource) async {
    final PickedFile image = await _imagePicker.getImage(source: imageSource);
    return image != null ? File(image.path) : null;
  }

  Future<File> _pickVideo(ImageSource imageSource) async {
    final PickedFile video = await _imagePicker.getVideo(source: imageSource);
    return video != null ? File(video.path) : null;
  }
}
