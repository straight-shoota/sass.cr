module Sass
  {% begin %}
  VERSION = {{ `cat shard.yml | grep "^version:" | head -n1`.split(":")[1].strip }}
  {% end %}
end
