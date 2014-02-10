class XirrNewtonCalculator
  # Calculate Xirr using Newton Raphson

  # Arguments
  #   flows: (Array)
  #   init_rate: (Fixnum, Bignum)
  #   max_iteration: (Fixnum)

  FlowStruct = Struct.new(:amount, :diff_date)
  EPS = 10 ** -7

  def initialize(flows, init_rate, max_iteration=10_000)
    initial_date = Date.parse flows[0].date.to_s
    @flows = flows.collect do |flow|
      FlowStruct.new(
        flow.amount,
        (Date.parse(flow.date.to_s) - initial_date) / 365.0
      )
    end
    @x_n = init_rate
    @max_iteration = max_iteration
  end

  def calculate(eps = EPS)
    @max_iteration.times do
      f(@x_n)
      break if @f_xn.abs < eps
      @x_n = next_value(@x_n)
    end
    @x_n
  end

  private 

    # Argument X_n
    # Returns X_n+1
    def next_value(x)
      x - @f_xn.to_f / dfdx(x)
    end

    def dfdx(x)
      @flows[1..-1].inject(0) do |result, flow|
        result += flow.amount * (-flow.diff_date) / ((1.0 + x) ** (flow.diff_date + 1.0))
      end
    end

    def f(x)
      @f_xn = @flows.inject(0) do |result, flow|
        result += flow.amount / ((1.0 + x) ** flow.diff_date)
      end
    end
end
