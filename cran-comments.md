## Release Summary

This is a **resubmission** of the package’s first release to CRAN.

Please note that 'BehaviorSpace' is an extension that comes bundled with 'NetLogo', so it would be inappropriate to include a separate reference link for it in the description.

## Latest CRAN Feedback

### 2025-10-06

"
Thanks,

The Description field is intended to be a (one paragraph) description of
what the package does and why it may be useful. Please add more details
about the package functionality and implemented methods in your
Description text.
For more details:
<https://contributor.r-project.org/cran-cookbook/general_issues.html#description-length>


Please omit the redundant "from R"/"AN R" at the end/start of your title
and description.

Please provide a link to the used webservices (NetLogo) to the
description field of your DESCRIPTION file in the form
<http:...> or <https:...>
with angle brackets for auto-linking and no space after 'http:' and
'https:'.
For more details:
<https://contributor.r-project.org/cran-cookbook/description_issues.html#references>

Please fix and resubmit.

Best,
Benjamin Altmann
"

### 2025-09-26

"
Thanks, we see:


   License components with restrictions and base license permitting such:
     GPL (>= 3) + file LICENSE
   File 'LICENSE':
     YEAR: 2025
     COPYRIGHT HOLDER: Daniel Vartanian

Please omit "+ file LICENSE" and the file itself which seems to be a
template for the MIT license?


   Possibly misspelled words in DESCRIPTION:
     NetLogo (2:12, 13:32, 14:47)

Please single quote software names in both Title and Description fields
of the DESCRIPTION file.


   Found the following (possibly) invalid file URI:
     URI: CODE_OF_CONDUCT.md
       From: README.md

There is no such  md file at this place?

Please fix and resubmit.

Best,
Uwe Ligges
"

## Responses to CRAN Feedbacks

- Removed `+ file LICENSE` and deleted the `LICENSE` file.
- Updated the `DESCRIPTION` file: "NetLogo" is now single quoted in both the Title and Description fields.
- Fixed the `README.md` link by replacing the reference to `CODE_OF_CONDUCT.md`.
- Fixed the Title and Description fields as requested.

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

There were 1 NOTE (excluding the *New submission* note).

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
