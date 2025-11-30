# Find NetLogo Executable File

`find_netlogo_console()` attempts to locate the NetLogo executable file
on the user's system.

It first checks the `NETLOGO_CONSOLE` environment variable. If this
variable is not set or the file does not exist, it constructs the path
to the executable based on the provided `netlogo_home` directory.

## Usage

``` r
find_netlogo_console(netlogo_home = find_netlogo_home(), remove_exe_ext = TRUE)
```

## Arguments

- netlogo_home:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the path to the NetLogo installation directory. If
  not provided, the function will try to find it automatically using
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md).
  (default:
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md)).

- remove_exe_ext:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to remove the `.exe` extension from the returned
  path on Windows systems (default: `TRUE`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string specifying
the path to the NetLogo executable file. If the file cannot be found, an
empty string is returned.

## See also

Other utility functions:
[`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
[`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md),
[`inspect_experiment_file()`](https://danielvartan.github.io/logolink/reference/inspect_experiment_file.md),
[`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  find_netlogo_console()
} # }
```
