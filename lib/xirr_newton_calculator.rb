class XirrNewtonCalculator
  # Calculate Xirr using Newton Raphson

  # Arguments
  #   flows: (Array)
  #   init_rate: (Fixnum, Bignum)
  #   max_iteration: (Fixnum)

  FlowStruct = Struct.new(:num, :pow)
  EPS = 10 ** -7

  def initialize(flows, init_rate, max_iteration=10_000)
    initial_date = Date.parse(flows[0].date.to_s)
    @f_flows = flows.collect do |flow|
      FlowStruct.new(
        flow.amount,
        (Date.parse(flow.date.to_s) - initial_date) / 365.0
      )
    end
    @dfdx_flows = @f_flows[1..-1].collect do |flow|
      FlowStruct.new(
        -(flow.num * flow.pow),
        flow.pow + 1.0
      )
    end
    @x = init_rate
    @max_iteration = max_iteration
  end

  def calculate(eps = EPS)
    @eps = eps
    @max_iteration.times do |n|
      prev_x = @x
      @x = next_value(@x)
      if @exit
        @x = prev_x if f(prev_x).abs < f(@x).abs
        break
      end
    end
    @x
  end

  private

    # Argument X_n
    # Returns X_n+1
    def next_value(x)
      next_x = x - f(x) / dfdx(x)
      @exit = x if (next_x - x).abs < @eps
      next_x
    end

    def dfdx(x)
      npv(x, @dfdx_flows)
    end

    def f(x)
      f_xn = npv(x, @f_flows)
      @exit = x if f_xn.abs < @eps
      f_xn
    end

    def npv(x, flows)
      flows.inject(0) do |result, flow|
        result += flow.num / ((1.0 + x) ** flow.pow)
      end
    end
end
