import 'package:flutter/material.dart';

extension MaterialStatePropertyExt<T> on T {
  MaterialStateProperty<T> asAllMaterialStateProperty() {
    return MaterialStateProperty.all(this);
  }
}
