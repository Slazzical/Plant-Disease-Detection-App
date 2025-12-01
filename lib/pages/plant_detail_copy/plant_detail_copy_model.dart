import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'plant_detail_copy_widget.dart' show PlantDetailCopyWidget;
import 'package:flutter/material.dart';

class PlantDetailCopyModel extends FlutterFlowModel<PlantDetailCopyWidget> {
  ///  Local state fields for this page.

  bool isLoading = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetWeather)] action in PlantDetailCopy widget.
  ApiCallResponse? weatherResponse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
