package com.example.jayaraj.flutter_altaoss;

import android.os.Bundle;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
