## Release Summary

This is a minor release in the 0.*.* series.

As of this version, the NetLogo path must now be set using an environment variable named `NETLOGO_HOME` (e.g., `Sys.setenv("NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.0"))`).

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

There were 1 NOTE.

### Note 1

```text
Possibly misspelled words in DESCRIPTION:
  programmatically (14:5)
```

This is a false positive. The word 'programmatically' is a valid English word.

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
♥ Ah! Rad package! Keep up the lovely work!
```

---

Thank you!

Daniel Vartanian
