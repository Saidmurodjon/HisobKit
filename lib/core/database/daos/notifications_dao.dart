import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'notifications_dao.g.dart';

@DriftAccessor(tables: [AppNotifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.db);

  /// Barcha xabarnomalar (yangi → eski)
  Stream<List<AppNotification>> watchAll() {
    return (select(appNotifications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// O'qilmagan xabarnomalar soni
  Stream<int> watchUnreadCount() {
    final query = selectOnly(appNotifications)
      ..addColumns([appNotifications.id.count()])
      ..where(appNotifications.isRead.equals(false));
    return query.map((row) => row.read(appNotifications.id.count()) ?? 0).watchSingle();
  }

  /// Xabarnomalarni Neon dan sinxronlash (upsert by remoteId)
  Future<void> upsertFromRemote(List<Map<String, dynamic>> items) async {
    await batch((b) {
      for (final item in items) {
        b.insertAll(
          appNotifications,
          [
            AppNotificationsCompanion.insert(
              remoteId: Value(item['id'] as int?),
              senderId: Value(item['senderId'] as String?),
              senderName: Value(item['senderName'] as String? ?? ''),
              type: Value(item['type'] as String? ?? 'system'),
              title: Value(item['title'] as String? ?? ''),
              body: Value(item['body'] as String? ?? ''),
              data: Value(
                item['data'] is String
                    ? item['data'] as String
                    : (item['data'] ?? '{}').toString(),
              ),
              isRead: Value(item['isRead'] as bool? ?? false),
              createdAt: Value(
                item['createdAt'] != null
                    ? DateTime.tryParse(item['createdAt'].toString()) ??
                        DateTime.now()
                    : DateTime.now(),
              ),
            ),
          ],
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  /// Bitta xabarnomani o'qilgan deb belgilash
  Future<void> markRead(int id) async {
    await (update(appNotifications)..where((t) => t.id.equals(id))).write(
      const AppNotificationsCompanion(isRead: Value(true)),
    );
  }

  /// Barchasini o'qilgan deb belgilash
  Future<void> markAllRead() async {
    await (update(appNotifications)..where((t) => t.isRead.equals(false)))
        .write(const AppNotificationsCompanion(isRead: Value(true)));
  }

  /// Eski xabarnomalarni tozalash (50 tadan ko'p bo'lsa)
  Future<void> pruneOld({int keepCount = 50}) async {
    final all = await (select(appNotifications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    if (all.length > keepCount) {
      final toDelete = all.skip(keepCount).map((e) => e.id).toList();
      await (delete(appNotifications)
            ..where((t) => t.id.isIn(toDelete)))
          .go();
    }
  }
}
