import '../../sql_engine.dart';
import '../utils/string_utils.dart';

/// Helper that returns encoder snippet for one column
String _enc(SqlColumn c, String f, int i) {
  final String b = '_b$i';
  switch (c.type) {
    case SqlType.integer:
      return '''
    // int ${c.name}
    buf.add(_i64($f as int));''';

    case SqlType.date:
      return '''
    // DateTime ${c.name}  → int64
    buf.add(_i64(
        ($f as DateTime).millisecondsSinceEpoch));''';

    case SqlType.real:
      return '''
    // double ${c.name}
    buf.add(_f64($f as double));''';

    case SqlType.boolean:
      return '''
    // bool ${c.name}
    buf.addByte($f == true ? 1 : 0);''';

    case SqlType.text:
      return '''
    // string ${c.name}
    final List<int> $b = utf8.encode($f as String);
    buf.add(_i32($b.length));
    buf.add($b);''';

    case SqlType.blob:
      return '''
    // blob ${c.name}
    buf.add(_i32(($f as List<int>).length));
    buf.add($f as List<int>);''';
  }
}

/// Helper that returns decoder snippet for one column
String _dec(SqlColumn c, String v, int i) {
  final String len = '_len$i';
  switch (c.type) {
    case SqlType.integer:
      return '''
    $v = _readI64();''';

    case SqlType.date:
      return '''
    $v = DateTime.fromMillisecondsSinceEpoch(_readI64());''';

    case SqlType.real:
      return '''
    $v = _readF64();''';

    case SqlType.boolean:
      return '''
    $v = _next() == 1;''';

    case SqlType.text:
      return '''
    final int $len = _readI32();
    $v = utf8.decode(input.sublist(_ofs, _ofs + $len));
    _ofs += $len;''';

    case SqlType.blob:
      return '''
    final int $len = _readI32();
    $v = input.sublist(_ofs, _ofs + $len);
    _ofs += $len;''';
  }
}

/// Generates the full binary codec extension
String generateBinarySerializer(String cls, List<SqlColumn> cols) {
  final StringBuffer enc = StringBuffer();
  final StringBuffer decPrep = StringBuffer(); // declarations
  final StringBuffer dec = StringBuffer(); // reads

  for (int i = 0; i < cols.length; i++) {
    final SqlColumn c = cols[i];
    final String f = 'this.${StringUtils.snakeToCamel(c.name)}';
    final String v = StringUtils.snakeToCamel(c.name);
    final String t = StringUtils.inferDartType(c);

    // ---------- ENCODER ----------
    if (c.nullable) {
      enc.writeln('''
    // nullable ${c.name}
    if ($f != null) {
      buf.addByte(1);${_enc(c, f, i)}
    } else {
      buf.addByte(0);
    }''');
    } else {
      enc.writeln(_enc(c, f, i));
    }

    // ---------- DECODER ----------
    if (c.nullable) {
      decPrep.writeln('$t? $v;');
      dec.writeln('''
    if (_next() == 1) {${_dec(c, v, i)}
    }''');
    } else {
      decPrep.writeln('late $t $v;');
      dec.writeln(_dec(c, v, i));
    }
  }

  final String ctor = cols
      .map((SqlColumn c) {
        final String n = StringUtils.snakeToCamel(c.name);
        return '$n: $n';
      })
      .join(', ');

  return '''
extension ${cls}Binary on $cls {
  // ---- helpers -----------------------------------------------------------
  static Uint8List _i32(int v) {
    final b = ByteData(4)..setInt32(0, v, Endian.little);
    return b.buffer.asUint8List();
  }
  static Uint8List _i64(int v) {
    final b = ByteData(8)..setInt64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }
  static Uint8List _f64(double v) {
    final b = ByteData(8)..setFloat64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  // ---- encode ------------------------------------------------------------
  Uint8List toBytes() {
    final buf = BytesBuilder();
$enc
    return buf.takeBytes();
  }

  // ---- decode ------------------------------------------------------------
  static $cls fromBytes(Uint8List input) {
    final bv  = input.buffer.asByteData();
    int _ofs  = 0;
    int _next() => input[_ofs++];          // 1 byte shortcut
    int _readI32()  { final v = bv.getInt32(_ofs, Endian.little); _ofs += 4; return v; }
    int _readI64()  { final v = bv.getInt64(_ofs, Endian.little); _ofs += 8; return v; }
    double _readF64(){ final v = bv.getFloat64(_ofs, Endian.little); _ofs += 8; return v; }

$decPrep
$dec
    return $cls($ctor);
  }
}
''';
}
