# This compiler provides a simple API to compile Sass and SCSS with `libsass`.
#
# Example usage:
# ```
# compiler = Sass::Compiler.new(include_path: "_scss")
# compiler.compile_file("main.scss")     # Compile file main.scss
# compiler.compile(%(@import "helper";)) # Import file _scss/helper.scss or _scss/_helper.scss
# ```
# # Options
#
# * **precision**: `Int32` – Precision for fractional numbers.
# * **output_style**: `OutputStyle` – Output style for the generated CSS code.
# * **source_comments**: `Bool` – Emit comments in the generated CSS indicating the corresponding
#   source line.
# * **source_map_embed**: `Bool` – embed sourceMappingUrl as data uri.
# * **source_map_contents**: `Bool` – embed include contents in maps.
# * **source_map_file_urls**: `Bool` – create file urls for sources.
# * **omit_source_map_url**: `Bool` – Disable `sourceMappingUrl` in css output.
# * **is_indented_syntax_src**: `Bool` – Treat `source_string` as sass (as opposed to scss)
# * **input_path**: `String` – The input path is used for source map generating. It can be used
#   to define something with string compilation or to overload the input file path. It is
#   set to `"stdin"` for data contexts and to the input file on file contexts.
# * **output_path**: `String` – The output path is used for source map generating. LibSass will not
#   write to this file, it is just used to create information in source-maps etc.
# * **indent**: `String` – String to be used for indentation.
# * **linefeed**: `String` – String to be used to for line feeds.
# * **include_path**: `String` – Colon-separated list of paths where `@import` directive looks for
#   include files (semicolon-separated on Windows).
# * **plugin_path**: `String` – Colon-separated list of paths for libsass plugins
#   (semicolon-separated on Windows).
# * **source_map_file**: `String` – Path to source map file. Enables the source map generating
#   used to create `sourceMappingUrl`.
# * **source_map_root**: `String` – Directly inserted in source maps.
#
# Please refer to the [`libsass` API documentation](https://github.com/sass/libsass/blob/master/docs/api-doc.md)
# for further details.
struct Sass::Compiler
  # :nodoc:
  OPTION_TYPES = {
    precision:              Int32,
    output_style:           OutputStyle,
    source_comments:        Bool,
    source_map_embed:       Bool,
    source_map_contents:    Bool,
    source_map_file_urls:   Bool,
    omit_source_map_url:    Bool,
    is_indented_syntax_src: Bool,
    indent:                 String,
    linefeed:               String,
    input_path:             String,
    output_path:            String,
    plugin_path:            String,
    include_path:           String,
    source_map_file:        String,
    source_map_root:        String,
  }

  module Options
    {% for name, option_type in OPTION_TYPES %}
      # Gets `libsass` option `{{name.id}}`.
      getter {{name.id}} : {{option_type}}?

      {% if option_type.resolve == String %}
      # Sets `libsass` option `{{name.id}}`.
      def {{name.id}}=(value : String?)
        @{{name.id}} = value.try &.check_no_null_byte
      end
      {% else %}
      # Sets `libsass` option `{{name.id}}`.
      setter {{name.id}} : {{option_type}}?
      {% end %}
    {% end %}
  end

  include Options

  {% begin %}
    # Creates a new compiler. All options can be assigned as named arguments.
    def initialize(*, {{
                        *OPTION_TYPES.keys.map do |option|
                          "@#{option.id} = nil".id
                        end
                      }})
      {% for name, option_type in OPTION_TYPES %}
        {% if option_type.resolve == String %}
          {{name}}.try &.check_no_null_byte
        {% end %}
      {% end %}
    end

    private def self.set_options(options, **option_values)
      {% for name, option_type in OPTION_TYPES %}
      unless (val = option_values[:{{name.id}}]?).nil?
        LibSass.option_set_{{name.id}}(options,
          {% if option_type.resolve == String %}
            val.check_no_null_byte
          {% else %}
            val
          {% end %})
      end
      {% end %}
    end

    def config
      {
        {% for name, option_type in OPTION_TYPES %}
          {{ name.id }}: {{ name.id }},
        {% end %}
      }
    end
  {% end %}

  # Compiles a Sass/SCSS string to CSS as `String`.
  #
  # For available options see class description.
  def compile(string, **options)
    Compiler.compile(string, **config.merge(**options))
  end

  # :nodoc:
  def self.compile(string, **option_values)
    # sass2scss converter in libsass frees the input string, so we need to create a new pointer
    string.check_no_null_byte
    malloc_string = LibC.malloc(string.bytesize + 1).as(UInt8*)
    malloc_string.copy_from string.to_unsafe, string.bytesize
    malloc_string[string.bytesize] = 0_u8
    data_context = LibSass.make_data_context(malloc_string)

    context = LibSass.data_context_get_context(data_context)

    options = LibSass.data_context_get_options(data_context)
    set_options options, **option_values
    LibSass.data_context_set_options(data_context, options)

    result = run_compiler context, LibSass.make_data_compiler(data_context)

    # if is_indented_syntax_src the parser frees the memory itself, otherwise we need to
    LibC.free(malloc_string) unless option_values[:is_indented_syntax_src]?

    result
  ensure
    LibSass.delete_data_context(data_context) if data_context
  end

  # Compiles a Sass/SCSS file to CSS as `String`.
  #
  # For available options see class description.
  def compile_file(file, **options)
    Compiler.compile_file(file, **config.merge(**options))
  end

  # :nodoc:
  def self.compile_file(file, **option_values)
    file_context = LibSass.make_file_context(file.check_no_null_byte)
    context = LibSass.file_context_get_context(file_context)

    options = LibSass.file_context_get_options(file_context)
    set_options options, **option_values
    LibSass.file_context_set_options(file_context, options)

    run_compiler context, LibSass.make_file_compiler(file_context)
  ensure
    LibSass.delete_file_context(file_context) if file_context
  end

  # Resolves a file in the given `include_path` via exact file name match.
  # def find_file(file)
  #   String.new LibSass.find_file(file, create_options)
  # end

  # Resolves a file in the given `include_path` via include file matching.
  # def find_include(file)
  #   String.new LibSass.find_include(file, create_options)
  # end

  private def self.run_compiler(context, compiler)
    LibSass.compiler_parse(compiler)
    LibSass.compiler_execute(compiler)

    compile_status = LibSass.context_get_error_status(context)

    raise_if_error context, compile_status

    String.new LibSass.context_get_output_string(context)
  ensure
    # For some reason freeing the compiler results in invalid memory access. Seems like it is reused.
    # LibSass.delete_compiler(compiler)
  end

  private def self.raise_if_error(context, status)
    return if status == LibSass::SassErrorStatus::NO_ERROR

    common = {
      message: String.new(LibSass.context_get_error_message(context)),
      status:  status,
      text:    String.new(LibSass.context_get_error_text(context)),
    }

    if status == LibSass::SassErrorStatus::BASE
      # BASE error status (code 1) is a source code error and has a location attached
      raise CompilerError.new(
        **common,
        file: String.new(LibSass.context_get_error_file(context)),
        line: LibSass.context_get_error_line(context),
        column: LibSass.context_get_error_column(context),
      )
    else
      raise CompilerError.new(**common)
    end
  end
end
