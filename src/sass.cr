module Sass
  alias OutputStyle = LibSass::SassOutputStyle

  # Returns the version of `libsass` as a `String`
  def self.libsass_version
    String.new(LibSass.libsass_version)
  end

  # Compiles a SASS/SCSS string and returns CSS as `String`.
  #
  # For available options see `Scss::Compiler`.
  def self.compile(string, **options)
    Compiler.new(**options).compile(string)
  end

  # Compiles a SASS/SCSS file and returns CSS as `String`.
  #
  # For available options see `Scss::Compiler`.
  def self.compile_file(file, **options)
    Compiler.new(**options).compile_file(file)
  end
end

require "./sass/lib_sass"
require "./sass/error"
require "./sass/compiler"
require "./sass/version"
