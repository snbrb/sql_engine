import 'package:sql_engine/sql_engine.dart';

part 'new_user.g.dart';

@SqlTable(tableName: 'Users', version: 1)
@SqlSchema(
  version: 1,
  columns: <SqlColumn>[
    SqlColumn(name: 'uid', type: 'TEXT', primaryKey: true, nullable: false),
    SqlColumn(name: 'displayName', type: 'TEXT', nullable: false),
    SqlColumn(name: 'profilePhotoUrl', type: 'TEXT', nullable: true),
    SqlColumn(name: 'locationLat', type: 'REAL', nullable: true),
    SqlColumn(name: 'locationLng', type: 'REAL', nullable: true),
    SqlColumn(name: 'voipToken', type: 'TEXT', nullable: true),
    SqlColumn(name: 'platform', type: 'TEXT', nullable: true),
    SqlColumn(name: 'firebaseToken', type: 'TEXT', nullable: true),
    SqlColumn(name: 'lastUpdated', type: 'INTEGER', nullable: true),
  ],
)
class NewUser {
  final String uid;
  final String displayName;
  final String? profilePhotoUrl;
  final double? locationLat;
  final double? locationLng;
  final String? voipToken;
  final String? platform;
  final String? firebaseToken;
  final int? lastUpdated;

  const NewUser({
    required this.uid,
    required this.displayName,
    this.profilePhotoUrl,
    this.locationLat,
    this.locationLng,
    this.voipToken,
    this.platform,
    this.firebaseToken,
    this.lastUpdated,
  });
}
