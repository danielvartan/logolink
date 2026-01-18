# Load Packages -----

library(beepr)
library(cffr)
library(checkmate)
library(codemetar)
library(fs)
library(groomr) # github.com/danielvartan/groomr
library(here)
library(readr)
library(rutils) # github.com/danielvartan/rutils
library(stringr)

# Remove Empty Lines from `README.md` -----

here("README.md") |> remove_blank_line_dups()

# Fix Image Links in `README.md` -----

readme_files_dir <- here("README_files")
readme_image_dir <- path(readme_files_dir, "figure-commonmark")
pkg_image_dir <- here("man", "figures")

if (test_directory_exists(readme_files_dir)) {
  if (test_directory_exists(readme_image_dir)) {
    dir_map(
      path = readme_image_dir,
      \(x) file_move(x, path(pkg_image_dir, basename(x)))
    )
  }

  dir_delete(readme_files_dir)
}

file <- here("README.md")

file |>
  read_lines() |>
  str_replace_all(
    pattern = "README_files/figure-commonmark/",
    replacement = "man/figures/"
  ) |>
  write_lines(file)

# Update Package Versions in `DESCRIPTION` -----

# update_pkg_versions(
#   ignore = c(
#     "dplyr",
#     "readr",
#     "xml2"
#   )
# )

# Update Package Year in `LICENSE` and `inst/CITATION` -----

here("inst", "CITATION") |> update_pkg_year()

# Update `cffr` and `codemeta` -----

cff_write()
write_codemeta()

# Check If the Script Ran Successfully -----

beep(1)

Sys.sleep(3)
