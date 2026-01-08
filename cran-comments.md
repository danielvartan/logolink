## Release Summary

This is a major release of `logolink` (version 1.0.0). The primary change in this release is the addition of support for NetLogo 7.0.1 and later.

NetLogo 7 received a patch release (7.0.1) that addressed several issues. This update also introduced a new XML structure for BehaviorSpace experiments, which required updates to `logolink` to ensure compatibility.

See the `NEWS.md` file for a detailed list of changes.

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

There were 0 ERRORs, 0 WARNINGs, and 0 NOTEs.

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
♥ Ah! Smashing package! Keep up the breathtaking work!
```

---

Thank you!

Daniel Vartanian
