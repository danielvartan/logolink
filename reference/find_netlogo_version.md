# Find NetLogo Version

`find_netlogo_version()` attempts to locate the NetLogo version
installed on the user's system.

It first tries to execute the NetLogo console with the `--version`
argument to retrieve the version information. If the executable is not
found, it attempts to extract the version number from the installation
directory name.

## Usage

``` r
find_netlogo_version(netlogo_home = find_netlogo_home())
```

## Arguments

- netlogo_home:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to the NetLogo installation directory. If
  not provided, the function will try to find it automatically using
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md).
  (default:
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the NetLogo version installed on the user's system. If the version
cannot be determined, an empty string is returned.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  find_netlogo_version()
} # }
```
