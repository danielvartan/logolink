# Find NetLogo Installation Directory

`find_netlogo_home()` attempts to locate the installation directory of
NetLogo on the user's system.

It first checks the `NETLOGO_HOME` environment variable. If this
variable is not set or the directory does not exist, it searches through
a list of common installation paths for NetLogo.

## Usage

``` r
find_netlogo_home()
```

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the path to the NetLogo installation directory. If the directory cannot
be found, an empty string is returned.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  find_netlogo_home()
} # }
```
