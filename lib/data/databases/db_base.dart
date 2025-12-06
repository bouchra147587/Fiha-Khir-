import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

/// Base database class that handles initialization and database connection
class DbBase {
  static final DbBase _instance = DbBase._internal();
  static Database? _database;
  static bool _initialized = false;

  factory DbBase() {
    return _instance;
  }

  DbBase._internal() {
    _initializeDatabaseFactory();
  }

  void _initializeDatabaseFactory() {
    if (!_initialized) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Initialize FFI for desktop platforms
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      _initialized = true;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // For desktop platforms, use current directory
      path = join(Directory.current.path, 'fiha_khir.db');
    } else {
      // For mobile platforms, use the default path
      path = join(await getDatabasesPath(), 'fiha_khir.db');
    }
    
    return await openDatabase(
      path,
      version: 3, // Incremented version for new structure
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Drop old tables and recreate
    await db.execute('DROP TABLE IF EXISTS problems');
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('DROP TABLE IF EXISTS organizations');
    await db.execute('DROP TABLE IF EXISTS organization_requests');
    await db.execute('DROP TABLE IF EXISTS history');
    await _onCreate(db, newVersion);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table - supports user, organization, and admin types
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        location TEXT NOT NULL,
        memberSince TEXT NOT NULL,
        problemsReported INTEGER NOT NULL DEFAULT 0,
        problemsSolved INTEGER NOT NULL DEFAULT 0,
        type TEXT NOT NULL,
        isVerified INTEGER NOT NULL DEFAULT 0,
        organizationDescription TEXT,
        organizationMembers INTEGER
      )
    ''');

    // Problems table - with approval status and photo support
    await db.execute('''
      CREATE TABLE problems (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        location TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        handledBy TEXT,
        reportedBy TEXT,
        isApproved INTEGER NOT NULL DEFAULT 0,
        beforePhotoPath TEXT,
        afterPhotoPath TEXT,
        rejectionReason TEXT,
        FOREIGN KEY (reportedBy) REFERENCES users(id),
        FOREIGN KEY (handledBy) REFERENCES users(id)
      )
    ''');

    // Organization requests table - for admin approval
    await db.execute('''
      CREATE TABLE organization_requests (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        email TEXT NOT NULL,
        contactPerson TEXT NOT NULL,
        status TEXT NOT NULL,
        rejectionReason TEXT,
        requestedDate TEXT NOT NULL,
        username TEXT,
        password TEXT,
        location TEXT,
        organizationDescription TEXT,
        organizationMembers INTEGER
      )
    ''');

    // History table for audit logs
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        action TEXT NOT NULL,
        entityType TEXT NOT NULL,
        entityId TEXT NOT NULL,
        userId TEXT,
        details TEXT,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}


