module StrategyDSL
  class << self
    def strategies
      @strategies ||= {}
    end
  end

  def strategy(name)
    s = Strategy.new
    yield s
    StrategyDSL.strategies[name] = s
  end

  class Strategy
    dsl_methods = %i{client_id client_secret scopes}

    dsl_methods.each do |meth|
      [meth, :"#{meth}="].each do |m|
        define_method m do |*args|
          if args.length == 0
            instance_variable_get(:"@#{meth}")
          elsif args.length == 1
            instance_variable_set(:"@#{meth}", args.first)
          else
            raise "#{m} takes 0 to 1 args"
          end
        end
      end
    end
  end
end
