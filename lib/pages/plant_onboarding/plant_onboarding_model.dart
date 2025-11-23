import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'plant_onboarding_widget.dart' show PlantOnboardingWidget;
import 'package:flutter/material.dart';

class PlantOnboardingModel extends FlutterFlowModel<PlantOnboardingWidget> {
  ///  Local state fields for this page.

  String? resultLabel;

  double? resultConfidence;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  bool isDataUploading_uploadedFileUrl = false;
  FFUploadedFile uploadedLocalFile_uploadedFileUrl =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadedFileUrl = '';

  // Stores action output result for [Backend Call - API (predictDisease)] action in Button widget.
  ApiCallResponse? apiResultd4k;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
