# Find NetLogo version

`find_netlogo_version()` attempts to determine the NetLogo version
installed on the user's system.

## Usage

``` r
find_netlogo_version()
```

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the NetLogo version (e.g., `"7.0.3"`). Returns
[`NA`](https://rdrr.io/r/base/NA.html) if the version cannot be
determined.

## Details

The function uses the following detection methods in order:

1.  **Console execution**: If the NetLogo console executable is found by
    [`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
    it runs `NetLogo_Console --headless --version` to retrieve the
    version information. This is the most reliable method.

2.  **Directory name extraction**: If the executable is not found, it
    attempts to extract the version number from the installation
    directory name returned by
    [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)
    (e.g., `NetLogo 7.0.2` yields `"7.0.2"`). Note that this fallback
    may produce slightly different results if the directory was renamed
    or uses a non-standard naming convention.

## See also

Other system functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)

## Examples

``` r
# \dontrun{
  find_netlogo_version()
#> [1] "7.0.3"
# }
```
