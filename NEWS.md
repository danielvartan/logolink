# logolink 0.1.0.9000 (development version)

- Added [`lifecycle`](https://lifecycle.r-lib.org/) as a dependency.
- Deprecated the `netlogo_path` argument in `run_experiment()`. The NetLogo path must now be set using an environment variable named `NETLOGO_HOME` (e.g., `Sys.setenv("NETLOGO_HOME" = file.path("C:", "Program Files", "NetLogo 7.0.0"))`).

# logolink 0.1.0

- First release! 🎉

# logolink 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
