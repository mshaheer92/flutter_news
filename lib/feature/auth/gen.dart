import 'dart:io';

void main() {
  generateCleanPackages();
}

void generateCleanPackages() {
  final String currentPath = Directory.current.path;
  final String filePath = Platform.script.path; // Get current Dart file path

  // Extract directory path from file path
  final int lastSeparatorIndex = filePath.lastIndexOf('/');
  final String directoryPath = filePath.substring(0, lastSeparatorIndex);

  // Create data directory with subfolders
  final dataDir = Directory('${directoryPath}/data');
  dataDir.createSync(recursive: true);

  // Create subfolders within data directory
  Directory('${dataDir.path}/repositories').createSync();
  Directory('${dataDir.path}/data_sources').createSync();
  Directory('${dataDir.path}/models').createSync();

  // Create domain directory with subfolders
  final domainDir = Directory('${directoryPath}/domain');
  domainDir.createSync(recursive: true);

  Directory('${domainDir.path}/entities').createSync();
  Directory('${domainDir.path}/repository').createSync();
  Directory('${domainDir.path}/usecases').createSync();

  // Create presentation directory with subfolders
  final presentationDir = Directory('${directoryPath}/presentation');
  presentationDir.createSync(recursive: true);

  Directory('${presentationDir.path}/pages').createSync();
  Directory('${presentationDir.path}/widgets').createSync();
  Directory('${presentationDir.path}/bloc').createSync();

  print('Clean packages generated successfully!');
}

