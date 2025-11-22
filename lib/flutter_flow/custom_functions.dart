import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

String? getTreatmentAdvice(
  String disease,
  String? weather,
) {
  String d = disease.toLowerCase();
  String w = (weather ?? "").toLowerCase();

  String treatment = "";

  // 2. Determine Base Treatment
  if (d.contains("healthy")) {
    return "Your plant looks healthy! No treatment needed. Keep monitoring regularly.";
  } else if (d.contains("bacterial")) {
    treatment = "Apply copper-based bactericides.";
  } else if (d.contains("fungi") ||
      d.contains("blight") ||
      d.contains("spot") ||
      d.contains("mold")) {
    treatment =
        "Apply broad-spectrum fungicides (e.g., Chlorothalonil or Copper). Remove infected leaves.";
  } else if (d.contains("mite") || d.contains("insect")) {
    treatment = "Use insecticidal soap or Neem oil.";
  } else if (d.contains("virus")) {
    return "Viral infections cannot be cured. Remove and destroy the infected plant to prevent spread.";
  } else {
    treatment = "Consult a local agricultural expert for specific advice.";
  }

  // 3. Apply Weather Logic
  if (w.contains("rain") || w.contains("drizzle") || w.contains("thunder")) {
    return "⚠️ WEATHER WARNING: It is currently raining.\n\n" +
        treatment +
        "\n\nHOWEVER: Do not spray now! Rain will wash the treatment away. Wait for dry weather.";
  } else if (w.contains("clear") || w.contains("sun")) {
    return "☀️ WEATHER TIP: It is sunny.\n\n" +
        treatment +
        "\n\nADVICE: Avoid spraying in direct mid-day sun to prevent leaf burn. Spray in the early morning or late evening.";
  } else if (w.contains("cloud")) {
    return "☁️ WEATHER TIP: It is cloudy.\n\n" +
        treatment +
        "\n\nThis is a good time to apply treatment as evaporation is lower.";
  }

  return treatment;
}

double? getLatitude(LatLng? location) {
  double getLatitude(LatLng location) {
    return location.latitude;
  }
}

double? getLongitude(LatLng? location) {
  double getLongitude(LatLng location) {
    return location.longitude;
  }
}
