# Find NetLogo installation directory

`find_netlogo_home()` attempts to locate the installation directory of
NetLogo on the user's system.

## Usage

``` r
find_netlogo_home()
```

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the path to the NetLogo installation directory. Returns an empty string
(`""`) if no installation can be found.

## Details

The function uses the following search order:

1.  Checks the `NETLOGO_HOME` environment variable. If set and the
    directory exists, returns that path.

2.  If the environment variable is not set or the directory does not
    exist, searches through common installation paths for directories
    containing "NetLogo" (case-insensitive) in their name.

If multiple NetLogo installations are found in the same directory, the
last one (alphabetically) is returned.

## See also

Other utility functions:
[`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
# \dontrun{
  find_netlogo_home()
#> /opt/NetLogo 7.0.3
# }
```
