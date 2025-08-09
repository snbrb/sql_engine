// --------------------------------------------------------------
//  binary_codec_test.dart
// --------------------------------------------------------------
import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/new_user.dart';
import 'models/order.dart';
import 'models/order_item.dart'; // ➜ generates OrderItemBinary

void main() {
  late SqlEngineDatabase database;

  setUpAll(() async {
    database = SqlEngineDatabase(enableLog: false);

    database.registerTable(<SqlEngineTable>[
      const OrderTable(),
      const OrderItemTable(),
      const NewUserTable(),
    ]);

    await database.open();
  });
  group('Binary codec • NewUser', () {
    test('1) round-trip with *only* required fields', () {
      final NewUser original = NewUser(uid: 'aa123', displayName: 'Alice');
      final NewUser decoded = NewUserBinary.fromBytes(original.toBytes());

      expect(decoded.uid, original.uid);
      expect(decoded.displayName, original.displayName);
      expect(decoded.profilePhotoUrl, isNull);
      expect(decoded.locationLat, isNull);
      expect(decoded.locationLng, isNull);
      expect(decoded.voipToken, isNull);
      expect(decoded.platform, isNull);
      expect(decoded.firebaseToken, isNull);
      expect(decoded.lastUpdated, isNull);
    });

    test('2) round-trip with every nullable field present', () {
      final NewUser original = NewUser(
        uid: 'μ-42', // Unicode
        displayName: 'Καλημέρα ☕',
        profilePhotoUrl: 'https://img/προφίλ.png',
        locationLat: 37.9838,
        locationLng: 23.7275,
        voipToken: base64.encode(List<int>.filled(32, 0xAB)),
        platform: 'android',
        firebaseToken: 'fcm_123',
        lastUpdated: DateTime(2099, 12, 31, 23, 59, 59).millisecondsSinceEpoch,
      );
      final NewUser decoded = NewUserBinary.fromBytes(original.toBytes());
      expect(decoded.uid, original.uid);
      expect(decoded.displayName, original.displayName);
      expect(decoded.profilePhotoUrl, original.profilePhotoUrl);
      expect(decoded.locationLat, closeTo(original.locationLat!, 1e-9));
      expect(decoded.locationLng, closeTo(original.locationLng!, 1e-9));
      expect(decoded.voipToken, original.voipToken);
      expect(decoded.platform, original.platform);
      expect(decoded.firebaseToken, original.firebaseToken);
      expect(decoded.lastUpdated, original.lastUpdated);
    });

    test('3) every nullable field = null', () {
      final NewUser original = NewUser(
        uid: 'x',
        displayName: 'N/A',
        profilePhotoUrl: null,
        locationLat: null,
        locationLng: null,
        voipToken: null,
        platform: null,
        firebaseToken: null,
        lastUpdated: null,
      );
      final NewUser decoded = NewUserBinary.fromBytes(original.toBytes());
      expect(decoded.profilePhotoUrl, isNull);
      expect(decoded.locationLat, isNull);
      expect(decoded.locationLng, isNull);
      expect(decoded.voipToken, isNull);
      expect(decoded.platform, isNull);
      expect(decoded.firebaseToken, isNull);
      expect(decoded.lastUpdated, isNull);
    });

    test('4) produces shorter byte stream when nullable values are NULL', () {
      final NewUser full = NewUser(
        uid: '1',
        displayName: 'f',
        profilePhotoUrl: 'url',
      );
      final NewUser sparse = NewUser(uid: '1', displayName: 'f');
      expect(sparse.toBytes().length, lessThan(full.toBytes().length));
    });

    test('5) multiple encode→decode cycles are idempotent', () {
      NewUser current = NewUser(
        uid: 'cycle',
        displayName: 'One',
        locationLat: 10.1,
      );
      for (int i = 0; i < 20; i++) {
        current = NewUserBinary.fromBytes(current.toBytes());
      }
      expect(current.displayName, 'One');
      expect(current.locationLat, closeTo(10.1, 1e-9));
    });

    test('6) truncating the byte stream throws', () {
      final Uint8List bytes = NewUser(uid: 'x', displayName: 'y').toBytes();
      expect(
        () => NewUserBinary.fromBytes(bytes.sublist(0, bytes.length - 1)),
        throwsRangeError,
      );
    });
  });

  group('Binary codec • OrderItem', () {
    test('7) simple round-trip', () {
      final OrderItem original = OrderItem(
        id: 99,
        orderId: 7,
        productName: 'Keyboard',
        quantity: 1,
        price: 199.99,
      );
      final OrderItem decoded = OrderItemBinary.fromBytes(original.toBytes());
      expect(decoded.id, original.id);
      expect(decoded.orderId, original.orderId);
      expect(decoded.productName, original.productName);
      expect(decoded.quantity, original.quantity);
      expect(decoded.price, closeTo(original.price, 1e-9));
    });

    test('8) zero quantity & zero price survive round-trip', () {
      final OrderItem original = OrderItem(
        id: 1,
        orderId: 1,
        productName: '',
        quantity: 0,
        price: 0,
      );
      final OrderItem decoded = OrderItemBinary.fromBytes(original.toBytes());
      expect(decoded.quantity, 0);
      expect(decoded.price, 0);
    });

    test('9) extreme quantity / price', () {
      final OrderItem original = OrderItem(
        id: 2,
        orderId: 2,
        productName: 'MegaPack',
        quantity: 2 << 30, // 1 073 741 824
        price: double.maxFinite / 2, // big but not inf
      );
      final OrderItem decoded = OrderItemBinary.fromBytes(original.toBytes());
      expect(decoded.quantity, original.quantity);
      expect(decoded.price, closeTo(original.price, 1e-3));
    });

    // test('10) byte content stable against manual encoder', () {
    //   //  manual: [id,orderId,productNameLen,productNameBytes,quantity,price]
    //   final BytesBuilder manual =
    //       BytesBuilder()
    //         ..add(ByteData(8)..setInt64(0, 1, Endian.little))
    //         ..add(ByteData(8)..setInt64(0, 1, Endian.little))
    //         ..add(ByteData(4)..setInt32(0, 3, Endian.little))
    //         ..add(utf8.encode('abc'))
    //         ..add(ByteData(8)..setInt64(0, 5, Endian.little))
    //         ..add(ByteData(8)..setFloat64(0, 9.9, Endian.little));
    //   final Uint8List fromGenerator =
    //       OrderItem(
    //         id: 1,
    //         orderId: 1,
    //         productName: 'abc',
    //         quantity: 5,
    //         price: 9.9,
    //       ).toBytes();
    //   expect(fromGenerator, manual.takeBytes());
    // });

    test('11) repeated encode→decode idempotent', () {
      OrderItem current = OrderItem(
        id: 3,
        orderId: 4,
        productName: 'Loop',
        quantity: 10,
        price: 1.5,
      );
      for (int i = 0; i < 15; i++) {
        current = OrderItemBinary.fromBytes(current.toBytes());
      }
      expect(current.quantity, 10);
      expect(current.price, closeTo(1.5, 1e-9));
    });
  });
}
