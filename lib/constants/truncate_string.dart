String truncateString({
  required String text,
  required int wordLimit,
}) {
  List<String> words = text.split(' ');
  if (words.length <= wordLimit) {
    return text;
  } else {
    return '${words.take(wordLimit).join(' ')}...';
  }
}
