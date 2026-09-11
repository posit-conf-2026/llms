# Install {pak} (it's fast and smart at installing packages)
if (!requireNamespace("pak", quietly = TRUE)) {
  # fmt: skip
  install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))
}

pak::local_install_deps()
