# A `CompilerError` is raised when `libsass` compiler encounters an error.
class Sass::CompilerError < Exception
  getter message
  getter status : LibSass::SassErrorStatus
  getter text : String
  getter file : String?
  getter line : UInt64?
  getter column : UInt64?

  def initialize(message : String, @status, @text, @file = nil, @line = nil, @column = nil, cause = nil)
    super(message, cause)
  end

  def to_s(io)
    io << "libsass compiler error (#{status}): #{message}"
  end

  def self.new(context, status)
    common = {
      message: String.new(LibSass.sass_context_get_error_message(context)),
      status:  status,
      text:    String.new(LibSass.sass_context_get_error_text(context)),
    }

    if status == LibSass::SassErrorStatus::BASE
      # BASE error status (code 1) is a source code error and has a location attached
      new(
        **common,
        file: String.new(LibSass.sass_context_get_error_file(context)),
        line: LibSass.sass_context_get_error_line(context),
        column: LibSass.sass_context_get_error_column(context),
      )
    else
      new(**common)
    end
  end
end
