import 'package:sql_engine/sql_engine.dart';
import 'package:sql_engine/src/enums/sql_type.dart';

part 'new_user.g.dart';

@SqlTable(tableName: 'Users', version: 1)
@SqlSchema(
  version: 1,
  columns: <SqlColumn>[
    SqlColumn(
      name: 'uid',
      type: SqlType.text,
      primaryKey: true,
      nullable: false,
    ),
    SqlColumn(name: 'displayName', type: SqlType.text, nullable: false),
    SqlColumn(name: 'profilePhotoUrl', type: SqlType.text, nullable: true),
    SqlColumn(name: 'locationLat', type: SqlType.real, nullable: true),
    SqlColumn(name: 'locationLng', type: SqlType.real, nullable: true),
    SqlColumn(name: 'voipToken', type: SqlType.text, nullable: true),
    SqlColumn(name: 'platform', type: SqlType.text, nullable: true),
    SqlColumn(name: 'firebaseToken', type: SqlType.text, nullable: true),
    SqlColumn(name: 'lastUpdated', type: SqlType.integer, nullable: true),
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
