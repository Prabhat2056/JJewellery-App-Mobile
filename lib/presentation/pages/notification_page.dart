import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/widgets/Global/appbar.dart';

import '../../main_common.dart';
import '../../utils/color_constant.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  Future<List<Map<String, dynamic>>> loadDataFromDb() async {
    final result =
        await db.rawQuery("SELECT * FROM Notifications ORDER BY date DESC");
    if (result.length > 20) {
      final idsToKeep = result.take(20).map((row) => row['id']).toList();
      final idsString = idsToKeep.join(',');
      await db
          .rawDelete("DELETE FROM Notifications WHERE id NOT IN ($idsString)");
      return await db
          .rawQuery("SELECT * FROM Notifications ORDER BY date DESC LIMIT 20");
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _notificationsFuture = loadDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: MyAppbar(
          isHomeWidget: false,
          title: "Notifications",
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading notifications"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No notifications yet."));
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationTile(
                  title: notification["title"] ?? "No Title",
                  description: notification["description"] ?? "",
                  date: notification["date"] ?? "",
                  index: index,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final int index;

  const _NotificationTile({
    required this.title,
    required this.description,
    required this.date,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(216, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: ColorConstant.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  date.split(" ")[0],
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstant.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
