# Changelog

## logolink 0.1.0.9000 (development version)

#### Breaking Changes

- Added support for NetLogo 7.0.1 and above. This NetLogo patch release
  changed the XML structure of BehaviorSpace experiments; `logolink` now
  supports the new format. See this [GitHub
  issue](https://github.com/NetLogo/NetLogo/issues/2560) to learn more.

#### New Features and Improvements

- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Added the parameter `timeout` to
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  to specify the maximum time (in seconds) to wait for an experiment to
  complete before terminating it.
- Added support for non-tabular data in
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md).
  The function now prints those outputs to the console.
- Added
  [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
  [`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
  and
  [`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md).
  These functions use heuristics to automatically detect NetLogo
  installations on Windows, macOS, and Linux.
- Added the parameter `file` to
  [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md),
  allowing the user to specify the output file path for the generated
  BehaviorSpace experiment XML file.
- Added new unit tests.
- Deprecated the `netlogo_path` argument in
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md).
  The package now tries to automatically detect the NetLogo installation
  using helper functions. Users can still manually specify the path to
  NetLogo; see the updated documentation for details.
- Improved the heuristics in
  [`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md).
- Improved the documentation.

## logolink 0.1.0

CRAN release: 2025-10-09

- First release! 🎉

## logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
