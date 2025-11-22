import '/components/plant_info/plant_info_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'plant_detail_widget.dart' show PlantDetailWidget;
import 'package:flutter/material.dart';

class PlantDetailModel extends FlutterFlowModel<PlantDetailWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for PlantInfo component.
  late PlantInfoModel plantInfoModel;

  @override
  void initState(BuildContext context) {
    plantInfoModel = createModel(context, () => PlantInfoModel());
  }

  @override
  void dispose() {
    plantInfoModel.dispose();
  }
}
