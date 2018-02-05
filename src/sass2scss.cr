module Sass
  # Converts a `String` with Sass code into SCSS.
  #
  # *prettify* takes the following values:
  # * `0`: Write everything on one line (`minimized`)
  # * `1`: Add lf after opening bracket (`lisp style`) *(default)*
  # * `2`: Add lf after opening and before closing bracket (`1TBS style`)
  # * `3`: Add lf before/after opening and before closing (`allman style`)
  #
  # *comments* takes these values:
  # * `:convert`: convert all comments to `/*`and `*/` delimiters *(default)*
  # * `:keep`: keep comments
  # * `:strip`: strip all comments
  #
  def self.sass2scss(content : String, prettify = 1, comments = :convert) : String
    case comments
    when :convert then options = LibSass::Sass2ScssOption::CONVERT_COMMENT
    when :keep    then options = LibSass::Sass2ScssOption::KEEP_COMMENT
    when :strip   then options = LibSass::Sass2ScssOption::STRIP_COMMENT
    else
      raise ArgumentError.new "invalid comments strategy option: #{comments.inspect}"
    end

    case prettify
    when 0
    when 1 then options |= LibSass::Sass2ScssOption::PRETTIFY_1
    when 2 then options |= LibSass::Sass2ScssOption::PRETTIFY_2
    when 3 then options |= LibSass::Sass2ScssOption::PRETTIFY_3
    else
      raise ArgumentError.new "invalid prettify option: #{prettify.inspect}"
    end

    sass2scss(content, options)
  end

  # :nodoc:
  def self.sass2scss(content : String, options : LibSass::Sass2ScssOption) : String
    String.new LibSass.sass2scss(content.check_no_null_byte, options)
  end
end
