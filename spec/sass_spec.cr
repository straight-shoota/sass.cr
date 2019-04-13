require "spec"

describe Sass do
  it "VERSION" do
    Sass::VERSION.should eq `shards version #{__DIR__}`.chomp
  end
end
