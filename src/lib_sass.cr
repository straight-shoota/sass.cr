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
  fun make_options = sass_make_options : SassOptions*

  # Create and initialize a specific context
  fun make_file_context = sass_make_file_context(input_path : Char*) : SassFileContext*
  fun make_data_context = sass_make_data_context(source_string : Char*) : SassDataContext*

  # Call the compilation step for the specific context
  fun compile_file_context = sass_compile_file_context(file_ctx : SassFileContext*) : Int32
  fun compile_data_context = sass_compile_data_context(data_ctx : SassDataContext*) : Int32

  # Create a sass compiler instance for more control
  fun make_file_compiler = sass_make_file_compiler(file_ctx : SassFileContext*) : SassCompiler*
  fun make_data_compiler = sass_make_data_compiler(data_ctx : SassDataContext*) : SassCompiler*

  # Execute the different compilation steps individually
  # Usefull if you only want to query the included files
  fun compiler_parse = sass_compiler_parse(compiler : SassCompiler*) : Int32
  fun compiler_execute = sass_compiler_execute(compiler : SassCompiler*) : Int32

  # Release all memory allocated with the compiler
  # This does _not_ include any contexts or options
  fun delete_compiler = sass_delete_compiler(compiler : SassCompiler*) : Void
  fun delete_options = sass_delete_options(compiler : SassCompiler*) : Void

  # Release all memory allocated and also ourself
  fun delete_data_context = sass_delete_data_context(ctx : SassDataContext*) : Void
  fun delete_file_context = sass_delete_file_context(ctx : SassFileContext*) : Void

  # Getters for Context from specific implementation
  fun file_context_get_context = sass_file_context_get_context(file_ctx : SassFileContext*) : SassContext*
  fun data_context_get_context = sass_data_context_get_context(data_ctx : SassDataContext*) : SassContext*

  # Getters for Context_Options from Sass_Context
  fun context_get_options = sass_context_get_options(ctx : SassContext*) : SassOptions*
  fun file_context_get_options = sass_file_context_get_options(file_ctx : SassFileContext*) : SassOptions*
  fun data_context_get_options = sass_data_context_get_options(data_ctx : SassDataContext*) : SassOptions*
  fun file_context_set_options = sass_file_context_set_options(file_ctx : SassFileContext*, opt : SassOptions*) : Void
  fun data_context_set_options = sass_data_context_set_options(data_ctx : SassDataContext*, opt : SassOptions*) : Void

  # Getters for Sass_Context values
  fun context_get_output_string = sass_context_get_output_string(ctx : SassContext*) : Char*
  fun context_get_error_status = sass_context_get_error_status(ctx : SassContext*) : SassErrorStatus
  fun context_get_error_json = sass_context_get_error_json(ctx : SassContext*) : Char*
  fun context_get_error_text = sass_context_get_error_text(ctx : SassContext*) : Char*
  fun context_get_error_message = sass_context_get_error_message(ctx : SassContext*) : Char*
  fun context_get_error_file = sass_context_get_error_file(ctx : SassContext*) : Char*
  fun context_get_error_line = sass_context_get_error_line(ctx : SassContext*) : LibC::SizeT
  fun context_get_error_column = sass_context_get_error_column(ctx : SassContext*) : LibC::SizeT
  fun context_get_source_map_string = sass_context_get_source_map_string(ctx : SassContext*) : Char*
  fun context_get_included_files = sass_context_get_included_files(ctx : SassContext*) : Char**

  # Getters for SassCompiler options (query import stack)
  fun compiler_get_import_stack_size = sass_compiler_get_import_stack_size(compiler : SassCompiler*) : LibC::SizeT
  fun compiler_get_last_import = sass_compiler_get_last_import(compiler : SassCompiler*) : SassImportEntry
  fun compiler_get_import_entry = sass_compiler_get_import_entry(compiler : SassCompiler*, idx : LibC::SizeT) : SassImportEntry
  # Getters for SassCompiler options (query function stack)
  fun compiler_get_callee_stack_size = sass_compiler_get_callee_stack_size(compiler : SassCompiler*) : LibC::SizeT
  fun compiler_get_last_callee = sass_compiler_get_last_callee(compiler : SassCompiler*) : SassCalleeEntry
  fun compiler_get_callee_entry = sass_compiler_get_callee_entry(compiler : SassCompiler*, idx : LibC::SizeT) : SassCalleeEntry

  fun compiler_get_state = sass_compiler_get_state(compiler : SassCompiler*) : SassCompilerState
  fun compiler_get_context = sass_compiler_get_context(compiler : SassCompiler*) : SassContext*
  fun compiler_get_options = sass_compiler_get_options(compiler : SassCompiler*) : SassOptions*

  # Take ownership of memory (value on context is set to 0)
  fun context_take_error_json = sass_context_take_error_json(ctx : SassContext*) : Char*
  fun context_take_error_text = sass_context_take_error_text(ctx : SassContext*) : Char*
  fun context_take_error_message = sass_context_take_error_message(ctx : SassContext*) : Char*
  fun context_take_error_file = sass_context_take_error_file(ctx : SassContext*) : Char*
  fun context_take_output_string = sass_context_take_output_string(ctx : SassContext*) : Char*
  fun context_take_source_map_string = sass_context_take_source_map_string(ctx : SassContext*) : Char*

  # Getters for Context_Option values
  fun option_get_precision = sass_option_get_precision(opt : SassOptions*) : Int32
  fun option_get_output_style = sass_option_get_output_style(opt : SassOptions*) : SassOutputStyle
  fun option_get_source_comments = sass_option_get_source_comments(opt : SassOptions*) : Bool
  fun option_get_source_map_embed = sass_option_get_source_map_embed(opt : SassOptions*) : Bool
  fun option_get_source_map_contents = sass_option_get_source_map_contents(opt : SassOptions*) : Bool
  fun option_get_source_map_file_urls = sass_option_get_source_map_file_urls(opt : SassOptions*) : Bool
  fun option_get_omit_source_map_url = sass_option_get_omit_source_map_url(opt : SassOptions*) : Bool
  fun option_get_is_indented_syntax_src = sass_option_get_is_indented_syntax_src(opt : SassOptions*) : Bool
  fun option_get_indent = sass_option_get_indent(opt : SassOptions*) : Char*
  fun option_get_linefeed = sass_option_get_linefeed(opt : SassOptions*) : Char*
  fun option_get_input_path = sass_option_get_input_path(opt : SassOptions*) : Char*?
  fun option_get_output_path = sass_option_get_output_path(opt : SassOptions*) : Char*?
  fun option_get_source_map_file = sass_option_get_source_map_file(opt : SassOptions*) : Char*?
  fun option_get_source_map_root = sass_option_get_source_map_root(opt : SassOptions*) : Char*?
  fun option_get_c_functions = sass_option_get_c_functions(opt : SassOptions*) : SassFunctionList
  fun option_get_importer = sass_option_get_importer(opt : SassOptions*) : SassImportCallback

  # Getters for Context_Option include path array
  fun option_get_include_path_size = sass_option_get_include_path_size(options : SassOptions*) : LibC::SizeT
  fun option_get_include_path = sass_option_get_include_path(options : SassOptions*, i : LibC::SizeT) : Char*
  # Plugin paths to load dynamic libraries work the same
  fun option_get_plugin_path_size = sass_option_get_plugin_path_size(options : SassOptions*) : LibC::SizeT
  fun option_get_plugin_path = sass_option_get_plugin_path(options : SassOptions*, i : LibC::SizeT) : Char*

  # Setters for Context_Option values
  fun option_set_precision = sass_option_set_precision(opt : SassOptions*, precision : Int32)
  fun option_set_output_style = sass_option_set_output_style(opt : SassOptions*, output_style : SassOutputStyle)
  fun option_set_source_comments = sass_option_set_source_comments(opt : SassOptions*, source_comments : Bool)
  fun option_set_source_map_embed = sass_option_set_source_map_embed(opt : SassOptions*, source_map_embed : Bool)
  fun option_set_source_map_contents = sass_option_set_source_map_contents(opt : SassOptions*, source_map_contents : Bool)
  fun option_set_source_map_file_urls = sass_option_set_source_map_file_urls(opt : SassOptions*, source_map_file_urls : Bool)
  fun option_set_omit_source_map_url = sass_option_set_omit_source_map_url(opt : SassOptions*, omit_source_map_url : Bool)
  fun option_set_is_indented_syntax_src = sass_option_set_is_indented_syntax_src(opt : SassOptions*, is_indented_syntax_src : Bool)
  fun option_set_indent = sass_option_set_indent(opt : SassOptions*, indent : Char*)
  fun option_set_linefeed = sass_option_set_linefeed(opt : SassOptions*, linefeed : Char*)
  fun option_set_input_path = sass_option_set_input_path(opt : SassOptions*, input_path : Char*)
  fun option_set_output_path = sass_option_set_output_path(opt : SassOptions*, output_path : Char*)
  fun option_set_plugin_path = sass_option_set_plugin_path(opt : SassOptions*, plugin_path : Char*)
  fun option_set_include_path = sass_option_set_include_path(opt : SassOptions*, include_path : Char*)
  fun option_set_source_map_file = sass_option_set_source_map_file(opt : SassOptions*, source_map_file : Char*)
  fun option_set_source_map_root = sass_option_set_source_map_root(opt : SassOptions*, source_map_root : Char*)
  fun option_set_c_functions = sass_option_set_c_functions(opt : SassOptions*, c_functions : SassFunctionList*)
  fun option_set_importer = sass_option_set_importer(opt : SassOptions*, importer : SassImportCallback*)

  # Push function for paths (no manipulation support for now)
  fun option_push_plugin_path = sass_option_push_plugin_path(options : SassOptions*, path : Char*) : Void
  fun option_push_include_path = sass_option_push_include_path(options : SassOptions*, path : Char*) : Void

  # Resolve a file via the given include paths in the sass option struct
  # find_file looks for the exact file name while find_include does a regular sass include
  fun find_file = sass_find_file(path : Char*, opt : SassOptions*) : Char*
  fun find_include = sass_find_include(path : Char*, opt : SassOptions*) : Char*

  # Resolve a file relative to last import or include paths in the sass option struct
  # find_file looks for the exact file name while find_include does a regular sass include
  fun compiler_find_file = sass_compiler_find_file(path : Char*, compiler : SassCompiler*) : Char*
  fun compiler_find_include = sass_compiler_find_include(path : Char*, compiler : SassCompiler*) : Char*

  @[Flags]
  enum Sass2ScssOption
    PRETTIFY_1,
    PRETTIFY_2,
    PRETTIFY_3,

    FILL1,
    FILL2,

    KEEP_COMMENT,
    STRIP_COMMENT,
    CONVERT_COMMENT
  end

  # Sass2Scss
  fun sass2scss_version : Char*
  fun sass2scss(sass : Char*, options : Sass2ScssOption) : Char*
end
