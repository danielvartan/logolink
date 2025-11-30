# logolink 0.1.0.9000 (development version)

### Breaking Changes

- Added support for NetLogo 7.0.1 and above. This NetLogo patch release changed the XML structure of BehaviorSpace experiments; `logolink` now supports the new format.

### New Features and Improvements

- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Added the parameter `timeout` to `run_experiment()` to specify the maximum time (in seconds) to wait for an experiment to complete before terminating it.
- Added support for non-tabular data in `run_experiment()`. The function now print those outputs in the console.
- Added `find_netlogo_home()`, `find_netlogo_console()`, and `find_netlogo_version()`. These functions use heuristics to automatically detect NetLogo installations on Windows, macOS, and Linux.
- Added the parameter `file` to `create_experiment()`, allowing the user to specify the output file path for the generated BehaviorSpace experiment XML file.
- Added new unit tests.
- Deprecated the `netlogo_path` argument in `run_experiment()`. The package now tries to automatically detect the NetLogo installation using helper functions. There is still an option to manually specify the path to NetLogo, which is explained in the updated documentation.
- Improved the heuristics in `parse_netlogo_list()`.
- Improved the documentation.

# logolink 0.1.0

- First release! 🎉

# logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
