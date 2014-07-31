module Paxmex
  require 'paxmex/parser'

  def self.method_missing(method_sym, *arguments, &block)
    if method_sym.to_s =~ /^parse_(.*)$/
      Parser.new(arguments.shift, $1).parse(*arguments)
    else
      super
    end
  end

end
