String _two(int n) => n.toString().padLeft(2, '0');

/// Simple "dd/mm HH:MM" format (intl dependency ke bina).
String formatDateTime(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)} ${_two(d.hour)}:${_two(d.minute)}';
