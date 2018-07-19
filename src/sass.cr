class Sass
  VERSION = "0.4.0"

  alias OutputStyle = LibSass::SassOutputStyle

  # Returns the version of `libsass` as a `String`
  def self.libsass_version
    String.new(LibSass.libsass_version)
  end

  # Compiles a Sass/SCSS string and returns CSS as `String`.
  #
  # For available options see `Sass::Options`.
  def self.compile(string, **options)
    Compiler.compile(string, **options)
  end

  # Compiles a Sass/SCSS file and returns CSS as `String`.
  #
  # For available options see `Sass::Options`.
  def self.compile_file(file, **options)
    Compiler.compile_file(file, **options)
  end
end

require "./lib_sass"
require "./error"
require "./compiler"
require "./sass2scss"
