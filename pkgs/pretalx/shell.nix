with import <nixpkgs> { };

mkShell {
  nativeBuildInputs = [
    libxslt.dev libxml2.dev # lxml
    pkgconfig
  ];
  buildInputs = [
    freetype libjpeg zlib libtiff libwebp tcl lcms2  # Pillow
    libxml2 libxslt  # lxml
    gettext  # Django
    postgresql_9_6  # Psycopg2
  ];
}
