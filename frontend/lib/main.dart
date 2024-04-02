import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/common/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 156, 27, 255),
  ),
  textTheme: GoogleFonts.redactedScriptTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();
  await dotenv.load();
  runApp(
    const ProviderScope(child: App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        headerBuilder:() => ClassicHeader(),
        // headerBuilder:() => WaterDropHeader(),
        // headerBuilder:() => MaterialClassicHeader(),
        // headerBuilder: () => WaterDropMaterialHeader(),
        headerTriggerDistance: 100.0, // header trigger refresh trigger distance
        springDescription: const SpringDescription(
          stiffness: 1200,
          damping: 100,
          mass: 2,
        ),
        skipCanRefresh:
            true, // custom spring back animate,the props meaning see the flutter api
        maxOverScrollExtent:
            100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
        maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
        enableScrollWhenRefreshCompleted:
            false, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
        enableLoadingWhenFailed:
            false, //In the case of load failure, users can still trigger more loads by gesture pull-up.
        hideFooterWhenNotFull:
            false, // Disable pull-up to load more functionality when Viewport is less than one screen
        enableBallisticLoad:
            false, // trigger load more by BallisticScrollActivity

        child: MaterialApp(
          title: 'Hostel Pass',
          theme: ThemeData(
            textTheme: GoogleFonts.amikoTextTheme(),
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0x00002e4c)),
            useMaterial3: true,
          ),
          home: const SplashPage(),
        ));
  }
}
