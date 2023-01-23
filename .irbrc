# Pretty print
require 'pp'

# Tab Completion
require 'irb/completion'
IRB.conf[:USE_READLINE] = true

# Histories
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:EVAL_HISTORY] = 100

# Set up prompt
IRB.conf[:PROMPT][:DYLAN] = {
  :PROMPT_I => '(%m):%03n:%i> ',
  :PROMPT_S => '(%m):%03n:%i> ',
  :PROMPT_C => '(%m):%03n:%i%l ',
  :PROMPT_N => '(%m):%03n:%i* ',
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

# A way to look at our history
def history(file=nil)
   if file
     File.open(file, "w") do |f|
       f.puts IRB::ReadlineInputMethod::HISTORY.to_a
     end
   else
     puts IRB::ReadlineInputMethod::HISTORY.to_a
   end
end
