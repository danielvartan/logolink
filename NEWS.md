# logolink 0.1.0.9000 (development version)

- Added support for NetLogo 7.0.1 and above. This NetLogo patch release changed the XML structure of BehaviorSpace experiments; `logolink` now supports the new format.
- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Deprecated the `netlogo_path` argument in `run_experiment()`. The NetLogo path must now be set using an environment variable named `NETLOGO_HOME` (e.g., `Sys.setenv("NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.2"))`).
- Improved the heuristics in `parse_netlogo_list()`.
- Improved the documentation.

# logolink 0.1.0

- First release! 🎉

# logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
