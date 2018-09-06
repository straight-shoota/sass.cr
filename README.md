# sass.cr

[![Build Status](https://travis-ci.org/straight-shoota/sass.cr.svg?branch=master)](https://travis-ci.org/straight-shoota/sass.cr)
[![Dependency Status](https://shards.rocks/badge/github/straight-shoota/crinja/status.svg)](https://shards.rocks/github/straight-shoota/crinja)
[![devDependency Status](https://shards.rocks/badge/github/straight-shoota/crinja/dev_status.svg)](https://shards.rocks/github/straight-shoota/crinja)

**sass.cr** provides a Sass/SCSS to CSS compiler for [Crystal](https://crystal-lang.org) through bindings to [`libsass`](https://github.com/sass/libsass/).

**[API Documentation](https://straight-shoota.github.io/sass.cr/api/latest/)** ·
**[GitHub Repo](https://github.com/straight-shoota/sass.cr)**

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  sass:
    github: straight-shoota/sass.cr
```

### Installing `libsass`

This shard requires the `libsass` library. It is available in many package managers as `libsass-dev` or `libsass`.

If you can't find a binary distribution of `libsass`, you need to build it yourself (see [Building instructions for `libsass`](https://github.com/sass/libsass/blob/master/docs/build.md)).

The included [Makefile](https://github.com/straight-shoota/sass.cr/blob/master/Makefile) contains a target `install-libsass` to install `libsass` in a global path (usually `/usr/local/lib`).
You can also run `make dep` to install `libsass` in a local path specified by `$LOCAL_LD_PATH` (by default this is `./dynlib`).

These bindings have been tested with version `3.4.5` and `3.5.0.beta.3` of `libsass`.

## Usage

```crystal
require "sass"

# Compile a Sass/SCSS file:
css = Sass.compile_file("application.scss")

# Compile a Sass/SCSS file with options:
css = Sass.compile_file("application.sass", include_path: "includes")

# Compile a Sass/SCSS string:
css = Sass.compile("body { div { color: red; } }")

# Re-use compiler with options:
compiler = Sass.new(include_path: "includes", precision: 4)
compiler.include_path += ":other_includes"
css_application = compiler.compile_file("application.scss")
css_layout = compiler.compile(%(@import "layout";))
```

## Contributing

1. Fork it ( https://github.com/straight-shoota/sass.cr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Johannes Müller](https://github.com/straight-shoota) - creator, maintainer
