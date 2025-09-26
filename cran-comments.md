## Release Summary

- This is the first release of the package to CRAN.

## Test Environments

- Local: Arch Linux (rolling), R-release
- GitHub Actions: Windows (Latest), R-release
- GitHub Actions: macOS (Latest), R-release
- GitHub Actions: Ubuntu (Latest), R-devel, R-release, R-oldrel
- r-project.org: Win builder, R-devel, R-release, R-oldrel
- r-project.org: macOS builder, R-release

## Local Calls

```r
devtools::check(remote = TRUE, manual = TRUE)
devtools::check_mac_release()
devtools::check_win_devel()
devtools::check_win_release()
devtools::check_win_oldrelease()
```

```r
lintr::lint_package()
urlchecker::url_check()
spelling::spell_check_package()
goodpractice::gp()
```

## R CMD Check Results (See *Test Environments*)

There were 0 ERRORs and 0 WARNINGs.

There were 2 NOTEs (excluding the *New submission* note).

### Note 1

```text
Possibly misspelled words in DESCRIPTION:
  NetLogo (2:12, 13:32, 14:47)
  programmatically (14:5)
```

These are false positives. The word 'NetLogo' refers to the NetLogo software. The word 'programmatically' is a valid English word.

## Note 2

```text
Found the following (possibly) invalid file URI:
  URI: CODE_OF_CONDUCT.md
    From: README.md
```

This is a false positive. The link to `CODE_OF_CONDUCT.md` is valid.

## `lintr` Results (Arch Linux)

```text
ℹ No lints found.
```

## `urlchecker` Results (Arch Linux)

```text
✔ All URLs are correct!
```

## `spelling` Results (Arch Linux)

```text
No spelling errors found.
```

## `goodpractice` Results (Arch Linux)

```text
♥ Heh! Tiptop package! Keep up the priceless work!
```

---

Thank you!

Daniel Vartanian
