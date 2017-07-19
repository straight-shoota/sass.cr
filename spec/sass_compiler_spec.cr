require "./spec_helper"

private INCLUDES_PATH = File.join(File.dirname(__FILE__), "includes")
private MESSAGES_FILE = File.join(INCLUDES_PATH, "messages")
private SIMPLE_CSS    = <<-'CSS'
  h1 {
    font-size: 12px; }

  h2 {
    font-size: 10px; }

  CSS

describe Sass::Compiler do
  describe "#compile" do
    it "compiles simple scss" do
      Sass.compile(%(body { div { color: red }})).should eq "body div {\n  color: red; }\n"
    end

    it "compiles simple sass" do
      Sass.compile(%(body\n  div\n    color: red\n), is_indented_syntax_src: true).should eq "body div {\n  color: red; }\n"
    end

    it "compiles sass file (default)" do
      Sass.compile_file(
        MESSAGES_FILE + ".sass"
      ).should eq File.read(MESSAGES_FILE + ".css")
    end

    it "compiles sass file (NESTED)" do
      Sass.compile_file(
        MESSAGES_FILE + ".sass",
        output_style: Sass::OutputStyle::NESTED
      ).should eq File.read(MESSAGES_FILE + ".nested.css")
    end

    it "compiles sass file (EXPANDED)" do
      Sass.compile_file(
        MESSAGES_FILE + ".sass",
        output_style: Sass::OutputStyle::EXPANDED
      ).should eq File.read(MESSAGES_FILE + ".expanded.css")
    end

    it "compiles sass file (COMPACT)" do
      Sass.compile_file(
        MESSAGES_FILE + ".sass",
        output_style: Sass::OutputStyle::COMPACT
      ).should eq File.read(MESSAGES_FILE + ".compact.css")
    end

    it "compiles sass file (COMPRESSED)" do
      Sass.compile_file(
        MESSAGES_FILE + ".sass",
        output_style: Sass::OutputStyle::COMPRESSED
      ).should eq File.read(MESSAGES_FILE + ".compressed.css")
    end

    it "compiles complex scss" do
      Sass::Compiler.new(output_style: LibSass::SassOutputStyle::EXPANDED).compile(<<-'SCSS'
        @for $i from 1 to 3 {
          h#{$i} {
            font-size: #{(7 - $i) * 2}px;
          }
        }
        SCSS).should eq <<-'CSS'
        h1 {
          font-size: 12px;
        }

        h2 {
          font-size: 10px;
        }

        CSS
    end

    it "resolves import" do
      Sass.compile(%(@import "simple";), include_path: INCLUDES_PATH).should eq SIMPLE_CSS
    end
  end

  describe "#compile_file" do
    it "compiles simple scss file" do
      Sass.compile_file(File.join(INCLUDES_PATH, "_simple.scss")).should eq SIMPLE_CSS
    end

    it "fails for non-existing scss file" do
      expect_raises(Sass::CompilerError, "File to read not found or unreadable") do
        Sass.compile_file("does_not_exist.scss")
      end
    end
  end

  # TODO: find_file returns emtpy string
  pending "#find_file" do
    it "finds file" do
      Sass::Compiler.new(include_path: INCLUDES_PATH).find_file("_simple.scss").should eq File.join(INCLUDES_PATH, "_simple.scss")
    end
  end

  # TODO: find_include returns emtpy string
  pending "#find_include" do
    it "finds file" do
      Sass::Compiler.new(include_path: INCLUDES_PATH).find_file("simple").should eq File.join(INCLUDES_PATH, "_simple.scss")
    end
  end
end
