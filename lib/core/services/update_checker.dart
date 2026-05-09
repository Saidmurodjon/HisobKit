import 'dart:convert';
import 'package:http/http.dart' as http;

const String _currentVersion = '1.1.1';
const String _repoOwner = 'Saidmurodjon';
const String _repoName = 'HisobKit';

class ReleaseInfo {
  final String version;       // e.g. "1.2.0"
  final String tagName;       // e.g. "v1.2.0"
  final String downloadUrl;   // direct APK asset URL
  final String releaseUrl;    // HTML release page
  final String body;          // release notes
  final DateTime publishedAt;
  final bool isNewer;

  const ReleaseInfo({
    required this.version,
    required this.tagName,
    required this.downloadUrl,
    required this.releaseUrl,
    required this.body,
    required this.publishedAt,
    required this.isNewer,
  });
}

class UpdateChecker {
  static Future<ReleaseInfo?> checkForUpdate() async {
    try {
      final uri = Uri.parse(
        'https://api.github.com/repos/$_repoOwner/$_repoName/releases/latest',
      );
      final response = await http
          .get(uri, headers: {'Accept': 'application/vnd.github.v3+json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = json['tag_name'] as String? ?? '';
      final version = tagName.replaceFirst('v', '');
      final body = json['body'] as String? ?? '';
      final publishedAt = DateTime.tryParse(
              json['published_at'] as String? ?? '') ??
          DateTime.now();
      final releaseUrl = json['html_url'] as String? ?? '';

      // Find APK asset
      final assets = (json['assets'] as List?) ?? [];
      String downloadUrl = releaseUrl;
      for (final asset in assets) {
        final name = (asset['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.apk')) {
          downloadUrl =
              asset['browser_download_url'] as String? ?? releaseUrl;
          break;
        }
      }

      final isNewer = _isVersionNewer(version, _currentVersion);

      return ReleaseInfo(
        version: version,
        tagName: tagName,
        downloadUrl: downloadUrl,
        releaseUrl: releaseUrl,
        body: body,
        publishedAt: publishedAt,
        isNewer: isNewer,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns true if [remote] > [current] using semver comparison.
  static bool _isVersionNewer(String remote, String current) {
    final r = _parseVersion(remote);
    final c = _parseVersion(current);
    for (int i = 0; i < 3; i++) {
      if (r[i] > c[i]) return true;
      if (r[i] < c[i]) return false;
    }
    return false;
  }

  static List<int> _parseVersion(String v) {
    final parts = v.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    while (parts.length < 3) {
      parts.add(0);
    }
    return parts;
  }

  static String get currentVersion => _currentVersion;
}
