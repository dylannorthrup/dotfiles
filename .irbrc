# Pretty print
require 'pp'

# From https://alchemists.io/projects/irb-kit
require "irb/kit"
IRB::Kit.register_helpers :all
IRB.conf[:PROMPT][:DYLANIRBKIT] = {
  PROMPT_I: "[#{IRB::Kit.prompt}]> ",
  PROMPT_N: "[#{IRB::Kit.prompt}]| ",
  PROMPT_C: "[#{IRB::Kit.prompt}]| ",
  PROMPT_S: "[#{IRB::Kit.prompt}]%l ",
  RETURN: "=> %s\n"
}

# Tab Completion
require 'irb/completion'
IRB.conf[:USE_READLINE] = true

# Set up prompt
IRB.conf[:PROMPT][:DYLAN] = {
  :PROMPT_I => "[#{IRB::Kit.prompt}] (%m):%03n:%i> ",
  :PROMPT_S => "[#{IRB::Kit.prompt}] (%m):%03n:%i> ",
  :PROMPT_C => "[#{IRB::Kit.prompt}] (%m):%03n:%i%l ",
  :PROMPT_N => "[#{IRB::Kit.prompt}] (%m):%03n:%i* ",
  :RETURN => "  ==> %s\n",
}
IRB.conf[:PROMPT_MODE] = :DYLAN
IRB.conf[:AUTO_INDENT] = true

def reset_irb
  exec($0)
end

# Update inspect methods to make them a little more compact for Arrays and Hashes
class Array
  alias :__orig_inspect :inspect

  def inspect
    (length > 20) ? "[ ... #{length} elements ... ]" : __orig_inspect
  end
end

class Hash
  alias :__orig_inspect :inspect

  def inspect
    (length > 20) ? "[ ... #{length} keys ... ]" : __orig_inspect
  end
end

# Making things indent automatically
IRB.conf[:AUTO_INDENT] = true

# Be able to use RI
def ri arg
  puts `ri #{arg}`
end

# Be able to use RI or a module. >> IO.ri "close"
class Module
  def ri(meth=nil)
    if meth
      if instance_methods(false).include? meth.to_s
        puts `ri #{self}##{meth}`
      else
        super
      end
    else
      puts `ri #{self}`
    end
  end
end

