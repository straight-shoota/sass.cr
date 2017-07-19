require "./spec_helper.cr"

describe "Sass::CompilerError" do
  it "generates error" do
    err = expect_raises(Sass::CompilerError, %(property "fail" must be followed by a ':')) do
      Sass.compile(%(body {\n  color: red;\n fail\n}))
    end
  end
end
