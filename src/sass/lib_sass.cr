# Bindings to `libsass`
@[Link("sass")]
lib LibSass
  alias Char = LibC::Char

  enum SassCompilerState
    CREATED
    PARSED
    EXECUTED
  end

  enum SassOutputStyle
    NESTED
    EXPANDED
    COMPACT
    COMPRESSED
  end

  enum SassErrorStatus
    NO_ERROR
    BASE
    BAD_ALLOC
    INTERNAL_EXCEPTION
    INTERNAL_STRING
    UNKNOWN
  end

  # Libsass types
  type SassOptions = Void*
  type SassContext = Void*
  type SassCompiler = Void*
  type SassFileContext = Void*
  type SassDataContext = Void*
  type SassImportCallback = Void*
  type SassFunctionList = Void*
  type SassImportEntry = Void*
  type SassCalleeEntry = Void*

  # Version
  fun libsass_version : Char*

  # Create and initialize an option struct
  fun sass_make_options : SassOptions*

  # Create and initialize a specific context
  fun sass_make_file_context(input_path : Char*) : SassFileContext*
  fun sass_make_data_context(source_string : Char*) : SassDataContext*

  # Call the compilation step for the specific context
  fun sass_compile_file_context(file_ctx : SassFileContext*) : Int32
  fun sass_compile_data_context(data_ctx : SassDataContext*) : Int32

  # Create a sass compiler instance for more control
  fun sass_make_file_compiler(file_ctx : SassFileContext*) : SassCompiler*
  fun sass_make_data_compiler(data_ctx : SassDataContext*) : SassCompiler*

  # Execute the different compilation steps individually
  # Usefull if you only want to query the included files
  fun sass_compiler_parse(compiler : SassCompiler*) : Int32
  fun sass_compiler_execute(compiler : SassCompiler*) : Int32

  # Release all memory allocated with the compiler
  # This does _not_ include any contexts or options
  fun sass_delete_compiler(compiler : SassCompiler*) : Void
  fun sass_delete_options(compiler : SassCompiler*) : Void

  # Release all memory allocated and also ourself
  fun sass_delete_data_context(ctx : SassDataContext*) : Void
  fun sass_delete_file_context(ctx : SassFileContext*) : Void

  # Getters for Context from specific implementation
  fun sass_file_context_get_context(file_ctx : SassFileContext*) : SassContext*
  fun sass_data_context_get_context(data_ctx : SassDataContext*) : SassContext*

  # Getters for Context_Options from Sass_Context
  fun sass_context_get_options(ctx : SassContext*) : SassOptions*
  fun sass_file_context_get_options(file_ctx : SassFileContext*) : SassOptions*
  fun sass_data_context_get_options(data_ctx : SassDataContext*) : SassOptions*
  fun sass_file_context_set_options(file_ctx : SassFileContext*, opt : SassOptions*) : Void
  fun sass_data_context_set_options(data_ctx : SassDataContext*, opt : SassOptions*) : Void

  # Getters for Sass_Context values
  fun sass_context_get_output_string(ctx : SassContext*) : Char*
  fun sass_context_get_error_status(ctx : SassContext*) : SassErrorStatus
  fun sass_context_get_error_json(ctx : SassContext*) : Char*
  fun sass_context_get_error_text(ctx : SassContext*) : Char*
  fun sass_context_get_error_message(ctx : SassContext*) : Char*
  fun sass_context_get_error_file(ctx : SassContext*) : Char*
  fun sass_context_get_error_line(ctx : SassContext*) : LibC::SizeT
  fun sass_context_get_error_column(ctx : SassContext*) : LibC::SizeT
  fun sass_context_get_source_map_string(ctx : SassContext*) : Char*
  fun sass_context_get_included_files(ctx : SassContext*) : Char**

  # Getters for SassCompiler options (query import stack)
  fun sass_compiler_get_import_stack_size(compiler : SassCompiler*) : LibC::SizeT
  fun sass_compiler_get_last_import(compiler : SassCompiler*) : SassImportEntry
  fun sass_compiler_get_import_entry(compiler : SassCompiler*, idx : LibC::SizeT) : SassImportEntry
  # Getters for SassCompiler options (query function stack)
  fun sass_compiler_get_callee_stack_size(compiler : SassCompiler*) : LibC::SizeT
  fun sass_compiler_get_last_callee(compiler : SassCompiler*) : SassCalleeEntry
  fun sass_compiler_get_callee_entry(compiler : SassCompiler*, idx : LibC::SizeT) : SassCalleeEntry

  fun sass_compiler_get_state(compiler : SassCompiler*) : SassCompilerState
  fun sass_compiler_get_context(compiler : SassCompiler*) : SassContext*
  fun sass_compiler_get_options(compiler : SassCompiler*) : SassOptions*

  # Take ownership of memory (value on context is set to 0)
  fun sass_context_take_error_json(ctx : SassContext*) : Char*
  fun sass_context_take_error_text(ctx : SassContext*) : Char*
  fun sass_context_take_error_message(ctx : SassContext*) : Char*
  fun sass_context_take_error_file(ctx : SassContext*) : Char*
  fun sass_context_take_output_string(ctx : SassContext*) : Char*
  fun sass_context_take_source_map_string(ctx : SassContext*) : Char*

  # Getters for Context_Option values
  fun sass_option_get_precision(opt : SassOptions*) : Int32
  fun sass_option_get_output_style(opt : SassOptions*) : SassOutputStyle
  fun sass_option_get_source_comments(opt : SassOptions*) : Bool
  fun sass_option_get_source_map_embed(opt : SassOptions*) : Bool
  fun sass_option_get_source_map_contents(opt : SassOptions*) : Bool
  fun sass_option_get_source_map_file_urls(opt : SassOptions*) : Bool
  fun sass_option_get_omit_source_map_url(opt : SassOptions*) : Bool
  fun sass_option_get_is_indented_syntax_src(opt : SassOptions*) : Bool
  fun sass_option_get_indent(opt : SassOptions*) : Char*
  fun sass_option_get_linefeed(opt : SassOptions*) : Char*
  fun sass_option_get_input_path(opt : SassOptions*) : Char*?
  fun sass_option_get_output_path(opt : SassOptions*) : Char*?
  fun sass_option_get_source_map_file(opt : SassOptions*) : Char*?
  fun sass_option_get_source_map_root(opt : SassOptions*) : Char*?
  fun sass_option_get_c_functions(opt : SassOptions*) : SassFunctionList
  fun sass_option_get_importer(opt : SassOptions*) : SassImportCallback

  # Getters for Context_Option include path array
  fun sass_option_get_include_path_size(options : SassOptions*) : LibC::SizeT
  fun sass_option_get_include_path(options : SassOptions*, i : LibC::SizeT) : Char*
  # Plugin paths to load dynamic libraries work the same
  fun sass_option_get_plugin_path_size(options : SassOptions*) : LibC::SizeT
  fun sass_option_get_plugin_path(options : SassOptions*, i : LibC::SizeT) : Char*

  # Setters for Context_Option values
  fun sass_option_set_precision(opt : SassOptions*, precision : Int32)
  fun sass_option_set_output_style(opt : SassOptions*, output_style : SassOutputStyle)
  fun sass_option_set_source_comments(opt : SassOptions*, source_comments : Bool)
  fun sass_option_set_source_map_embed(opt : SassOptions*, source_map_embed : Bool)
  fun sass_option_set_source_map_contents(opt : SassOptions*, source_map_contents : Bool)
  fun sass_option_set_source_map_file_urls(opt : SassOptions*, source_map_file_urls : Bool)
  fun sass_option_set_omit_source_map_url(opt : SassOptions*, omit_source_map_url : Bool)
  fun sass_option_set_is_indented_syntax_src(opt : SassOptions*, is_indented_syntax_src : Bool)
  fun sass_option_set_indent(opt : SassOptions*, indent : Char*)
  fun sass_option_set_linefeed(opt : SassOptions*, linefeed : Char*)
  fun sass_option_set_input_path(opt : SassOptions*, input_path : Char*)
  fun sass_option_set_output_path(opt : SassOptions*, output_path : Char*)
  fun sass_option_set_plugin_path(opt : SassOptions*, plugin_path : Char*)
  fun sass_option_set_include_path(opt : SassOptions*, include_path : Char*)
  fun sass_option_set_source_map_file(opt : SassOptions*, source_map_file : Char*)
  fun sass_option_set_source_map_root(opt : SassOptions*, source_map_root : Char*)
  fun sass_option_set_c_functions(opt : SassOptions*, c_functions : SassFunctionList*)
  fun sass_option_set_importer(opt : SassOptions*, importer : SassImportCallback*)

  # Push function for paths (no manipulation support for now)
  fun sass_option_push_plugin_path(options : SassOptions*, path : Char*) : Void
  fun sass_option_push_include_path(options : SassOptions*, path : Char*) : Void

  # Resolve a file via the given include paths in the sass option struct
  # find_file looks for the exact file name while find_include does a regular sass include
  fun sass_find_file(path : Char*, opt : SassOptions*) : Char*
  fun sass_find_include(path : Char*, opt : SassOptions*) : Char*

  # Resolve a file relative to last import or include paths in the sass option struct
  # find_file looks for the exact file name while find_include does a regular sass include
  fun sass_compiler_find_file(path : Char*, compiler : SassCompiler*) : Char*
  fun sass_compiler_find_include(path : Char*, compiler : SassCompiler*) : Char*

  # Sass2Scss
  fun sass2scss_version : Char*
  fun sass2scss(sass : Char*, options : Int32) : Char*
end
