enum URL {
  posts;

  final String _basePath = 'https://jsonplaceholder.typicode.com';

  String value() {
    return '$_basePath/$name';
  }
}
