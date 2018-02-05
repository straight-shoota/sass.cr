require "./spec_helper"

describe "Sass.sass2scss" do
  it "converts simple sass" do
    Sass.sass2scss("p\n  color: red").should eq "p\n{\n  color: red;\n}\n"
  end

  it "converts with prettify option" do
    Sass.sass2scss("p\n  color: red", prettify: :minimized).should eq "p { color: red; }"
    Sass.sass2scss("p\n  color: red", prettify: :lisp_style).should eq "p {\n  color: red; }\n"
    Sass.sass2scss("p\n  color: red", prettify: :otbs_style).should eq "p {\n  color: red;\n}\n"
    Sass.sass2scss("p\n  color: red", prettify: :allman_style).should eq "p\n{\n  color: red;\n}\n"
    Sass.sass2scss("p\n  color: red").should eq "p\n{\n  color: red;\n}\n"
  end

  it "converts with comments option" do
    Sass.sass2scss("// comment", comments: :keep).should eq "// comment\n"
    Sass.sass2scss("// comment", comments: :strip).should eq ""
    Sass.sass2scss("// comment", comments: :convert).should eq "/* comment */\n"
    Sass.sass2scss("// comment").should eq "/* comment */\n"
  end

  it "handles null byte" do
    expect_raises ArgumentError, "String contains null byte" do
      Sass.sass2scss("p\n  color: red\0")
    end
  end
end
