with import <nixpkgs> { };

mkShell {

  SOURCE_DATE_EPOCH = "315532800"; # 1980

  nativeBuildInputs = [
    libxslt.dev libxml2.dev # lxml
    pkgconfig
  ];

  buildInputs = [
    freetype libjpeg zlib libtiff libwebp tcl lcms2  # Pillow
    libxml2 libxslt  # lxml
    gettext  # Django
    postgresql_9_6  # Psycopg2
    libffi  # cffi
    openssl  # cryptography
  ];

}
