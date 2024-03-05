import 'package:flutter/material.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:hostel_pass_management/widgets/rt/rt_drawer.dart';
import 'package:hostel_pass_management/widgets/student/student_drawer.dart';
import 'package:hostel_pass_management/widgets/warden/warden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    SharedPreferences? prefs = SharedPreferencesManager.preferences;
    var drawer;
    if (prefs!.getString("role") == "student") {
      drawer = StudentDrawer();
    } else if (prefs.getString("role") == "rt") {
      drawer = RtDrawer();
    } else if (prefs.getString("role") == "warden") {
      drawer = WardenDrawer();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      drawer: drawer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.announcement,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.announcement,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.announcement,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              title: const Text("Announcement Title"),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.announcement,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              subtitle: const Text("Lorem Ipsum"),
              children: const [
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
                Text(
                  "lknsofnvon osln ldj flo flso fndoinosdfn losd fnosdnfi ndifon oldinf ion olind f nid fnldn f; pdnf pkdnf ikpn dfk ndfkn ;dfk ndpi fn",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
