# A `CompilerError` is raised when `libsass` compiler encounters an error.
class Sass::CompilerError < Exception
  getter message, status

  def initialize(@message : String, @status : Int32, cause = nil)
    super("libsass compiler error (#{status}): #{message}", cause)
  end
end
