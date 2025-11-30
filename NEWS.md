# logolink 0.1.0.9000 (development version)

- Added support for NetLogo 7.0.1 and above. This NetLogo patch release changed the XML structure of BehaviorSpace experiments; `logolink` now supports the new format.
- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Deprecated the `netlogo_path` argument in `run_experiment()`. The package now tries to automatically detect the NetLogo installation using helper functions. There is still an option to manually specify the path to NetLogo, which is explained in the updated documentation.
- Added the parameter `timeout` to `run_experiment()` to specify the maximum time (in seconds) to wait for an experiment to complete before terminating it.
- Added support for non-tabular data in `run_experiment()`. The function now print those outputs in the console.
- Added `find_netlogo_home()`, `find_netlogo_console()`, and `find_netlogo_version()`. These functions use heuristics to automatically detect NetLogo installations on Windows, macOS, and Linux.
- Added new unit tests.
- Improved the heuristics in `parse_netlogo_list()`.
- Improved the documentation.

# logolink 0.1.0

- First release! 🎉

# logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
