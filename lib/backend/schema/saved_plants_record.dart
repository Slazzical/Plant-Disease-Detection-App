import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Plant information
class SavedPlantsRecord extends FirestoreRecord {
  SavedPlantsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "disease_name" field.
  String? _diseaseName;
  String get diseaseName => _diseaseName ?? '';
  bool hasDiseaseName() => _diseaseName != null;

  // "confidence" field.
  String? _confidence;
  String get confidence => _confidence ?? '';
  bool hasConfidence() => _confidence != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "treatment_advice" field.
  String? _treatmentAdvice;
  String get treatmentAdvice => _treatmentAdvice ?? '';
  bool hasTreatmentAdvice() => _treatmentAdvice != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  void _initializeFields() {
    _diseaseName = snapshotData['disease_name'] as String?;
    _confidence = snapshotData['confidence'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _treatmentAdvice = snapshotData['treatment_advice'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _userRef = snapshotData['user_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('saved_plants');

  static Stream<SavedPlantsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SavedPlantsRecord.fromSnapshot(s));

  static Future<SavedPlantsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SavedPlantsRecord.fromSnapshot(s));

  static SavedPlantsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SavedPlantsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SavedPlantsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SavedPlantsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SavedPlantsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SavedPlantsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSavedPlantsRecordData({
  String? diseaseName,
  String? confidence,
  String? imageUrl,
  String? treatmentAdvice,
  DateTime? createdAt,
  DocumentReference? userRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'disease_name': diseaseName,
      'confidence': confidence,
      'image_url': imageUrl,
      'treatment_advice': treatmentAdvice,
      'created_at': createdAt,
      'user_ref': userRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class SavedPlantsRecordDocumentEquality implements Equality<SavedPlantsRecord> {
  const SavedPlantsRecordDocumentEquality();

  @override
  bool equals(SavedPlantsRecord? e1, SavedPlantsRecord? e2) {
    return e1?.diseaseName == e2?.diseaseName &&
        e1?.confidence == e2?.confidence &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.treatmentAdvice == e2?.treatmentAdvice &&
        e1?.createdAt == e2?.createdAt &&
        e1?.userRef == e2?.userRef;
  }

  @override
  int hash(SavedPlantsRecord? e) => const ListEquality().hash([
        e?.diseaseName,
        e?.confidence,
        e?.imageUrl,
        e?.treatmentAdvice,
        e?.createdAt,
        e?.userRef
      ]);

  @override
  bool isValidKey(Object? o) => o is SavedPlantsRecord;
}
