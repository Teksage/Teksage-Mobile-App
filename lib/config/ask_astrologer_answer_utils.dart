import 'package:astro_prompt/config/ask_astrologer_config.dart';
import 'package:intl/intl.dart';

bool _isAbsoluteProfileUrl(String value) {
  final raw = value.trim().toLowerCase();
  return raw.startsWith('http://') || raw.startsWith('https://');
}

String? _trimTrailingSlash(String path) {
  final trimmed =
      path.endsWith('/') && path.length > 1 ? path.substring(0, path.length - 1) : path;
  return trimmed == '/' ? null : trimmed;
}

/// Path-only values become `/slug`; full URLs are returned unchanged.
String? normalizeAstrologerProfilePath(String? value) {
  if (value == null) return null;

  final raw = value.trim();
  if (raw.isEmpty) return null;

  if (_isAbsoluteProfileUrl(raw)) {
    final uri = Uri.tryParse(raw);
    if (uri == null || uri.host.isEmpty) return null;
    final path = uri.path.isEmpty ? '' : _trimTrailingSlash(uri.path) ?? '';
    return uri.hasScheme && uri.host.isNotEmpty
        ? '${uri.scheme}://${uri.host}$path'
        : null;
  }

  final path = raw.startsWith('/') ? raw : '/$raw';
  return _trimTrailingSlash(path);
}

bool hasValidAstrologerProfilePath(String? value) {
  return normalizeAstrologerProfilePath(value) != null;
}

String buildAstrologerPublicProfileUrl(String profilePath) {
  final normalized = normalizeAstrologerProfilePath(profilePath);
  if (normalized == null) return AskAstrologerScreenCopy.publicSiteOrigin;
  if (_isAbsoluteProfileUrl(normalized)) return normalized;
  return '${AskAstrologerScreenCopy.publicSiteOrigin}$normalized';
}

String buildAstrologerPublicProfileDisplayUrl(String profilePath) {
  final normalized = normalizeAstrologerProfilePath(profilePath);
  if (normalized == null) return AskAstrologerScreenCopy.publicSiteHost;
  if (_isAbsoluteProfileUrl(normalized)) {
    final uri = Uri.parse(normalized);
    final path = uri.path.isEmpty ? '' : _trimTrailingSlash(uri.path) ?? '';
    return '${uri.host}$path';
  }
  return '${AskAstrologerScreenCopy.publicSiteHost}$normalized';
}

String? formatAskAnswerDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return DateFormat('dd/MM/yyyy, h:mm a')
        .format(DateTime.parse(value).toLocal());
  } catch (_) {
    return null;
  }
}
