class Sass
  @[Deprecated]
  VERSION = "0.6.0"

  alias OutputStyle = LibSass::SassOutputStyle

  # Returns the version of `libsass` as a `String`
  def self.libsass_version
    String.new(LibSass.libsass_version)
  end
end

require "./lib_sass"
require "./error"
require "./compiler"
require "./sass2scss"
