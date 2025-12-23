# Find NetLogo version

`find_netlogo_version()` attempts to determine the NetLogo version
installed on the user's system.

## Usage

``` r
find_netlogo_version(netlogo_home = find_netlogo_home())
```

## Arguments

- netlogo_home:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to the NetLogo installation directory. If
  not provided, the function will try to find it automatically using
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)
  (default:
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the NetLogo version (e.g., `"7.0.2"`). Returns an empty string (`""`) if
the version cannot be determined.

## Details

The function uses the following detection methods in order:

1.  **Console execution**: If the NetLogo console executable is found,
    it runs `NetLogo_Console --version` to retrieve the version
    information. This is the most reliable method.

2.  **Directory name extraction**: If the executable is not found, it
    attempts to extract the version number from the installation
    directory name (e.g., `netlogo-7.0.2` yields `"7.0.2"`).

Note that the directory name fallback may produce slightly different
results if the directory was renamed or uses a non-standard naming
convention.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
# \dontrun{
  find_netlogo_version()
#> [1] "7.0.3"
# }
```
