# A `CompilerError` is raised when `libsass` compiler encounters an error.
class Sass::CompilerError < Exception
  alias Status = LibSass::SassErrorStatus

  getter message
  getter status : Status
  getter text : String
  getter file : String?
  getter line : UInt64?
  getter column : UInt64?

  def initialize(message : String, @status, @text, @file = nil, @line = nil, @column = nil, cause = nil)
    super(message, cause)
  end

  # :nodoc:
  def to_s(io)
    io << "libsass compiler error (#{status}): #{message}"
  end
end
