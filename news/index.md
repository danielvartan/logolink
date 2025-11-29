# Changelog

## logolink 0.1.0.9000 (development version)

- Added support for NetLogo 7.0.1 and above. This NetLogo patch release
  changed the XML structure of BehaviorSpace experiments; `logolink` now
  supports the new format.
- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Deprecated the `netlogo_path` argument in
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md).
  The NetLogo path must now be set using an environment variable named
  `NETLOGO_HOME` (e.g.,
  `Sys.setenv("NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.2"))`).
- Added the parameter `timeout` to
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  to specify the maximum time (in seconds) to wait for an experiment to
  complete before terminating it.
- Added support for non-tabular data in
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md).
  The function now print those outputs in the console.
- Added heuristics to automatically detect NetLogo installation paths on
  Windows, macOS, and Linux.
- Added new unit tests.
- Improved the heuristics in
  [`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md).
- Improved the documentation.

## logolink 0.1.0

CRAN release: 2025-10-09

- First release! 🎉

## logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
