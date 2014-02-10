class XirrNewtonCalculator
  # Calculate Xirr using Newton Raphson

  # Arguments
  #   flows: (Array)
  #   init_rate: (Fixnum, Bignum)
  #   max_iteration: (Fixnum)

  EPS = 10 ** -10

  def initialize(flows, init_rate, max_iteration=10_000)
    initial_date = Date.parse flows[0].date.to_s
    @flows = flows.collect do |flow|
      {
        amount: flow.amount,
        diff_date: (Date.parse(flow.date.to_s) - initial_date) / 365.0
      }
    end
    @x_n = init_rate
    @max_iteration = max_iteration
  end

  def calculate(eps = EPS)
    f(@x_n)
    @max_iteration.times do
      break if @f_xn.abs < eps
      @x_n = next_value(@x_n)
    end
    @x_n
  end

  private 

    # Argument X_n
    # Returns X_n+1
    def next_value(x)
      x - f(x) / dfdx(x)
    end

    def dfdx(x)
      @flows[1..-1].inject(0) do |result, flow|
        result += flow[:amount] * (-flow[:diff_date]) / ((1.0 + x) ** (flow[:diff_date] + 1.0))
      end
    end

    def f(x)
      @f_xn = @flows.inject(0) do |result, flow|
        result += flow[:amount] / ((1.0 + x) ** flow[:diff_date])
      end
    end
end
