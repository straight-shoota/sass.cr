# This compiler provides a simple API to compile SASS and SCSS with `libsass`.
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
  OPTIONS = {
    :precision              => Int32,
    :output_style           => OutputStyle,
    :source_comments        => Bool,
    :source_map_embed       => Bool,
    :source_map_contents    => Bool,
    :source_map_file_urls   => Bool,
    :omit_source_map_url    => Bool,
    :is_indented_syntax_src => Bool,
    :indent                 => String,
    :linefeed               => String,
    :input_path             => String,
    :output_path            => String,
    :plugin_path            => String,
    :include_path           => String,
    :source_map_file        => String,
    :source_map_root        => String,
  }

  {% for name, option_type in OPTIONS %}
    # Sets `libsass` option `{{name.id}}`.
    property {{name.id}} : {{option_type}}?
  {% end %}

  {% begin %}
    # Creates a new compiler. All options can be assigned as named arguments.
    def initialize(*, {{
                        *OPTIONS.keys.map do |option|
                          "@#{option.id} = nil".id
                        end
                      }})
    end
  {% end %}

  # Compiles a SASS/SCSS string to CSS.
  def compile(string)
    # sass2scss converter in libsass frees the input string, so we need to create a new pointer
    malloc_string = LibC.strdup(string)
    data_context = LibSass.sass_make_data_context(malloc_string)

    context = LibSass.sass_data_context_get_context(data_context)

    options = LibSass.sass_data_context_get_options(data_context)
    set_options options
    LibSass.sass_data_context_set_options(data_context, options)

    result = run_compiler context, LibSass.sass_make_data_compiler(data_context)

    # if is_indented_syntax_src the parser frees the memory itself, otherwise we need to
    LibC.free(malloc_string) unless is_indented_syntax_src

    result
  ensure
    LibSass.sass_delete_data_context(data_context) if data_context
  end

  # Compiles a SASS/SCSS file to CSS.
  def compile_file(file)
    file_context = LibSass.sass_make_file_context(file)
    context = LibSass.sass_file_context_get_context(file_context)

    options = LibSass.sass_file_context_get_options(file_context)
    set_options(options)
    LibSass.sass_file_context_set_options(file_context, options)

    run_compiler context, LibSass.sass_make_file_compiler(file_context)
  ensure
    LibSass.sass_delete_file_context(file_context) if file_context
  end

  # Resolves a file in the given `include_path` via exact file name match.
  # def find_file(file)
  #   String.new LibSass.sass_find_file(file, create_options)
  # end

  # Resolves a file in the given `include_path` via include file matching.
  # def find_include(file)
  #   String.new LibSass.sass_find_include(file, create_options)
  # end

  private def run_compiler(context, compiler)
    LibSass.sass_compiler_parse(compiler)
    LibSass.sass_compiler_execute(compiler)

    compile_status = LibSass.sass_context_get_error_status(context)

    if compile_status != LibSass::SassErrorStatus::NO_ERROR
      raise CompilerError.new(context, compile_status)
    end

    String.new LibSass.sass_context_get_output_string(context)
  ensure
    # For some reason freeing the compiler results in invalid memory access. Seemslike it is reused.
    # LibSass.sass_delete_compiler(compiler)
  end

  private def create_options
    LibSass.sass_make_options.tap do |options|
      set_options options
    end
  end

  private def set_options(options)
    {% for name, option_type in OPTIONS %}
    unless (val = {{name.id}}).nil?
      LibSass.sass_option_set_{{name.id}}(options, val)
    end
    {% end %}
  end
end

lib LibC
  fun strdup(source : Char*) : Char*
end
