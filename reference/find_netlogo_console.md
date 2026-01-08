# Find NetLogo executable file

`find_netlogo_console()` attempts to locate the NetLogo executable file
on the user's system.

## Usage

``` r
find_netlogo_console()
```

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the path to the NetLogo executable file. Returns
[`NA`](https://rdrr.io/r/base/NA.html) if the executable cannot be found
at any location.

## Details

The function uses the following search order:

1.  Checks the `NETLOGO_CONSOLE` environment variable. If set and the
    file exists, returns that path.

2.  If the environment variable is not set or the file does not exist,
    constructs and expands the path based on the output of
    [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)
    (e.g., `<NETLOGO_HOME>/NetLogo_Console.exe` on Windows or
    `<NETLOGO_HOME>/NetLogo_Console` for other systems).

## See also

Other system functions:
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md)

## Examples

``` r
# \dontrun{
  find_netlogo_console()
#> /opt/NetLogo 7.0.3/bin/NetLogo
# }
```
