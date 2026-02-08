enum FileFilterEnum {
  all('Tous les fichiers'),
  owner('Mes fichiers'),
  viewer('Fichiers partagés avec moi'),
  pdf('PDF'),
  image('Images'),
  document('Documents'),
  csv('Tableurs');

  final String label;

  const FileFilterEnum(this.label);
}
