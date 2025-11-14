import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_update_helper/force_update_helper.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '/src/app.dart';
import '/src/common_widgets/show_alert_dialog.dart';
import '/src/env/env.dart';
import '/src/theme/app_theme.dart';
import '/src/utils/package_info_provider.dart';
import '/src/utils/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      // Use the beforeSend callback to filter which events are sent
      options.beforeSend = (SentryEvent event, dynamic hint) {
        // Ignore events that are not in release mode
        if (!kReleaseMode) {
          return null;
        }
        // If there was no response, it means that a connection error occurred
        // Do not log this to Sentry
        final exception = event.throwable;
        if (exception is DioException && exception.response == null) {
          return null;
        }
        // For all other events, return the event as is
        return event;
      };
    },
  );

  final container = ProviderContainer();
  // Eagerly initialize SharedPreferences
  await container.read(sharedPreferencesProvider.future);
  await container.read(packageInfoProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      themeMode: .light,
      theme: AppTheme.lightTheme(),
      navigatorKey: _rootNavigatorKey,
      builder: (context, child) {
        return ForceUpdateWidget(
          navigatorKey: _rootNavigatorKey,
          forceUpdateClient: ForceUpdateClient(
            // TODO: Real apps should fetch this from an API endpoint or via Firebase Remote Config
            fetchRequiredVersion: () => Future.value('0.1.0'),
            iosAppStoreId: Env.appStoreId,
          ),
          allowCancel: false,
          showForceUpdateAlert: (context, allowCancel) => showAlertDialog(
            context: context,
            title: 'App Update Required',
            content: 'Please update to continue using the app.',
            cancelActionText: allowCancel ? 'Later' : null,
            defaultActionText: 'Update Now',
          ),
          showStoreListing: (storeUrl) async {
            if (await canLaunchUrl(storeUrl)) {
              await launchUrl(
                storeUrl,
                mode: .externalApplication,
              );
            } else {
              log('Cannot launch URL: $storeUrl');
            }
          },
          onException: (e, st) {
            log(e.toString());
          },
          child: child!,
        );
      },
      home: const CurrencyConverterApp(),
    );
  }
}
