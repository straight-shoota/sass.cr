# sass.cr

[![Build Status](https://travis-ci.org/straight-shoota/sass.cr.svg?branch=master)](https://travis-ci.org/straight-shoota/sass.cr)
[![Dependency Status](https://shards.rocks/badge/github/straight-shoota/crinja/status.svg)](https://shards.rocks/github/straight-shoota/crinja)
[![devDependency Status](https://shards.rocks/badge/github/straight-shoota/crinja/dev_status.svg)](https://shards.rocks/github/straight-shoota/crinja)

**sass.cr** provides a SASS/SCSS to CSS compiler for [Crystal](https://crystal-lang.org) through bindings to [`libsass`](https://github.com/sass/libsass/).

**[API Documentation](https://straight-shoota.github.io/sass.cr/api/latest/)**

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  sass:
    github: straight-shoota/sass.cr
```

### Building `libsass`
There is currently no binary distribution of `libsass`, so you need to build it yourself (see [Building instructions for `libsass`](https://github.com/sass/libsass/blob/master/docs/build.md)). The following commands download the source code from the Github repository and build a dynamic library:

```bash
export SASS_LIBSASS_PATH=/usr/local/lib/libsass
git clone https://github.com/sass/libsass.git "$SASS_LIBSASS_PATH" --branch="3.5.0.beta.3"
BUILD="shared" make -C "$SASS_LIBSASS_PATH" -j5
sudo PREFIX="/usr/local" make -C "$SASS_LIBSASS_PATH" install
sudo cp "${SASS_LIBSASS_PATH}/lib/libsass.so" /usr/local/lib
sudo ldconfig
```

You can also take a look at our [install script](scripts/install_libsass_ci.sh) that builds `libsass` for travis-ci.
These bindings have been tested with version `3.4.5` and `3.5.0.beta.3`.

## Usage

```crystal
require "sass"

# Compile a SASS/SCSS file:
css = Sass.compile_file("application.scss")
# Compile a SASS/SCSS file with options:
css = Sass.compile_file("application.sass", include_path: "incluldes")
# Compile a SASS/SCSS string:
css = Sass.compile("body { div { color: red; } }")
# Re-use compiler with options:
compiler = Sass::Compiler.new(include_path: "incluldes", precision: 4)
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
