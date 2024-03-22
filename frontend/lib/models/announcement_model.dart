class Announcement {
  Announcement({
    required this.rtId,
    required this.title,
    required this.message,
    required this.isBoysHostelRt,
    required this.blockNo,
    required this.announcementId,
    required this.isRead,
  });
  final String rtId;
  final String announcementId;
  final bool isBoysHostelRt;
  final bool isRead;
  final String title;
  final String message;
  final int blockNo;
}
