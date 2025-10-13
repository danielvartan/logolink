# Contributing to `logolink`

<!-- This CONTRIBUTING.md was adapted from https://gist.github.com/peterdesmet/e90a1b0dc17af6c12daf6e8b2f044e7c -->

First of all, thank you for considering a contribution to `logolink`! Your interest and involvement are what make it rewarding for us—the project maintainers—to continue developing and improving `logolink`.

`logolink` is an open source project, maintained by people who care. We are not directly funded to do so.

[repo]: https://github.com/danielvartan/logolink
[issues]: https://github.com/danielvartan/logolink/issues
[new_issue]: https://github.com/danielvartan/logolink/issues/new
[website]: https://danielvartan.github.io/logolink
[citation]: https://danielvartan.github.io/logolink/authors.html

## How You Can Contribute

There are several ways you can contribute to this project. If you want to know more about why and how to contribute to open source projects like this one, see this [Open Source Guide](https://opensource.guide/how-to-contribute/).

### Give It a Star ⭐

[![GitHub repo stars](https://img.shields.io/github/stars/danielvartan/logolink)](https://github.com/danielvartan/logolink/)

If you find `logolink` helpful, please consider starring the repository on GitHub. It helps others discover the project and shows your support!

### Share `logolink` with Others 📣

Think `logolink` is useful? Let others discover it, by telling them in person, via Twitter or a blog post.

### Sponsor `logolink` 💖

[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/danielvartan)

If you want to support `logolink` and its development, consider [sponsoring the project](https://github.com/sponsors/danielvartan). Your support helps us maintain and improve the project, and it allows us to dedicate more time to its development. Don't forget to mention `logolink` in your sponsorship message.

### Cite `logolink` in Your Work 📝

Are you using `logolink` in a publication or project? Please consider [citing it][citation]. Citations help support the project and demonstrate its impact to the community.

### Propose an Idea 💡

Have an idea for a new `logolink` feature? Take a look at the [documentation][website] and [issue list][issues] to see if it isn't included or suggested yet. If not, suggest your idea as an [issue on GitHub][issues]. While we can't promise to implement your idea, it helps to:

- Explain in detail how it would work.
- Keep the scope as narrow as possible.

See below if you want to contribute code for your idea as well.

### Report a Bug 🐛

Using `logolink` and discovered a bug? That's annoying! Don't let others have the same experience and report it as an [issue on GitHub][new_issue] so we can fix it. A good bug report makes it easier for us to do so, so please include:

* The content of `utils::sessionInfo()`.
* Any details about your local setup that might be helpful in troubleshooting.
* Detailed steps to reproduce the bug (Tip: Use the [reprex](https://reprex.tidyverse.org/) package).

### Improve the Documentation 📖

Noticed a typo on the website? Think a function could use a better example? Good documentation makes all the difference, so your help to improve it is very welcome!

#### The Website

The [website][website] is generated with [`pkgdown`](http://pkgdown.r-lib.org/). That means we don't have to write any HTML: Content is pulled together from documentation in the code, vignettes, [Markdown](https://guides.github.com/features/mastering-markdown/) files, the package `DESCRIPTION` and `_pkgdown.yml` settings. If you know your way around `pkgdown`, you can [propose a file change](https://help.github.com/articles/editing-files-in-another-user-s-repository/) to improve documentation.

#### Function Documentation

Functions are described as comments near their code and translated to documentation using [`roxygen2`](https://klutometis.github.io/roxygen/). If you want to improve a function description:

1. Go to the `R` directory in the [code repository][repo].
2. Look for the file with the function.
3. [Propose a file change](https://help.github.com/articles/editing-files-in-another-user-s-repository/) to update the function documentation in the roxygen comments (starting with `#'`).

### Contribute Code 📝

Care to fix bugs or implement new functionality for `logolink`? Awesome! 👏 Have a look at the [issue list][issues] and leave a comment on the things you want to work on. See also the development guidelines below.

## Code of Conduct

[![Contributor Covenant 3.0 Code of Conduct](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Development Guidelines

We follow the [GitHub Flow](https://guides.github.com/introduction/flow/) for development. This means all changes should be made in feature branches, submitted as pull requests, and reviewed before merging into the main branch. Please keep your branches focused on a single topic or fix to make reviews easier and the project history clearer. Here are the steps to follow:

1. Fork [this repo][repo] and clone it to your computer. To learn more about this process, see [this guide](https://guides.github.com/activities/forking/).
2. If you have forked and cloned the project before, and it has been a while since you worked on it, [pull changes from the original repo](https://help.github.com/articles/merging-an-upstream-repository-into-your-fork/) to your clone by using `git pull upstream main`.
3. Open the project in your [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment).
4. Make your changes:
    - Write your code.
    - Test your code (bonus points for adding unit tests).
    - Document your code (see function documentation above).
    - Check your code with `devtools::check()` and aim for 0 errors, warnings, and notes.
5. Commit and push your changes.
6. Submit a [pull request](https://guides.github.com/activities/forking/#making-a-pull-request).

Please ensure your code adheres to the [tidyverse design guide](https://principles.tidyverse.org/) and the [tidyverse style guide](https://style.tidyverse.org/). All contributions should follow these principles and conventions to maintain consistency and readability throughout the project.
