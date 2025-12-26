# Changelog

## logolink 1.0.0.9000 (development version)

#### Breaking Changes

- `logolink` now works only with NetLogo 7.0.1 and above. This NetLogo
  patch release changed the XML structure of BehaviorSpace experiments;
  See this [GitHub
  issue](https://github.com/NetLogo/NetLogo/issues/2560) to learn more.
- [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  had the `parse` argument removed. The function now offer an option to
  return a [lists
  output](https://docs.netlogo.org/behaviorspace.html#lists-output) via
  the new `output` parameter. Results containing data in NetLogo’s lists
  format are returned as `character` vectors. See
  [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  documentation for details.
- [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  had the `netlogo_path` argument removed. The package now tries to
  automatically detect the NetLogo installation using helper functions.
  Users can still manually specify the path to NetLogo. See the updated
  documentation for details.

#### New Features and Improvements

- [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  now have a `timeout` parameter to specify the maximum time (in
  seconds) to wait for an experiment to complete before terminating it.
- [`run_experiment()`](https://danielvartan.github.io/logolink/reference/run_experiment.md)
  now prints to the R console any messages returned by NetLogo while
  running the simulation.
- [`find_netlogo_home()`](https://danielvartan.github.io/logolink/reference/find_netlogo_home.md),
  [`find_netlogo_console()`](https://danielvartan.github.io/logolink/reference/find_netlogo_console.md),
  and
  [`find_netlogo_version()`](https://danielvartan.github.io/logolink/reference/find_netlogo_version.md)
  were introduced to the package. These functions use heuristics to
  automatically detect NetLogo installations on Windows, macOS, and
  Linux.
- [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  now have a `file` parameter, allowing the user to specify the output
  file path for the generated BehaviorSpace experiment XML file.
- [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  now supports multiple commands in arguments like `setup` and `go` as
  character vectors.
- [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  now supports vectors in `constants` for enumerated value sets.
- [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  now supports
  [subexperiments](https://docs.netlogo.org/behaviorspace.html#subexperiment-syntax).
- [`create_experiment()`](https://danielvartan.github.io/logolink/reference/create_experiment.md)
  is now feature complete. It attends all the functionalities described
  in the [XML File
  Format](https://github.com/NetLogo/NetLogo/wiki/XML-File-Format#behaviorspace-experiments)
  documentation.
- [`parse_netlogo_list()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_list.md)
  now have better heuristics.
- [`parse_netlogo_color()`](https://danielvartan.github.io/logolink/reference/parse_netlogo_color.md)
  was introduced to parse NetLogo color strings into approximate hex
  color codes.
- New unit tests were implemented.
- A [new
  vignette](https://danielvartan.github.io/logolink/articles/visualizing-the-netlogo-world.html)
  showing how to visualize the NetLogo world using
  [`ggplot2`](https://ggplot2.tidyverse.org/) was added.
- The documentation was updated to reflect the changes in the package.

## logolink 0.1.0

CRAN release: 2025-10-09

- First release! 🎉

## logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
