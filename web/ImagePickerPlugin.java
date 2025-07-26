package com.example.todo;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;

/** ImagePickerPlugin */
public class ImagePickerWebPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding.getPlatformViewRegistry().registerViewFactory(
      "plugins.flutter.io/image_picker/image_picker",
      new ImagePickerPlugin(binding.getBinaryMessenger()));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}
}
