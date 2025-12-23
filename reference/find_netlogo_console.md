# Find NetLogo executable file

`find_netlogo_console()` attempts to locate the NetLogo executable file
on the user's system.

## Usage

``` r
find_netlogo_console(netlogo_home = find_netlogo_home())
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
the path to the NetLogo executable file. Returns an empty string (`""`)
if the executable cannot be found at any location.

## Details

The function uses the following search order:

1.  Checks the `NETLOGO_CONSOLE` environment variable. If set and the
    file exists, returns that path.

2.  If the environment variable is not set or the file does not exist,
    constructs the path based on `netlogo_home` (e.g.,
    `<netlogo_home>/NetLogo_Console` on Linux/macOS or
    `<netlogo_home>/NetLogo_Console.exe` on Windows).

## See also

Other utility functions:
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
# \dontrun{
  find_netlogo_console()
#> /opt/NetLogo-7.0.3/bin/NetLogo
# }
```
