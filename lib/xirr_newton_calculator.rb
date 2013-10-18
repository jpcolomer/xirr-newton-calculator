class XirrNewtonCalculator
	# Calculate Xirr using Newton Raphson

	# Arguments
	# 	flows: (Array)
	# 	init_rate: (Fixnum, Bignum)
	# 	max_iteration: (Fixnum)


	EPS = 10 ** -7

	attr_writer :f_xn

  def initialize(flows, init_rate, max_iteration=1000)
   @flows = flows
   @x_n = init_rate < 1 ? 1 / (1 + init_rate) : 0.5
   @max_iteration = max_iteration
  end

  def calculate
  	@f_xn = f(@x_n)
  	iteration = 0
  	while @f_xn.abs >= EPS && iteration <= @max_iteration
  		@f_xn = f(@x_n)
    	@x_n = next_value(@x_n)
    	iteration += 1
    end
    discount_factor_to_irr(@x_n)
  end

  private 

  # Argument X_n
  # Returns X_n+1
  def next_value(x)
  	x - @f_xn.to_f/dfdx(x)
  end

  def dfdx(x)
  	@flows[1..-1].inject(0) do |result, flow|
  		diff_date = (Date.parse(flow.date.to_s) - Date.parse(@flows[0].date.to_s))/365
  		result += flow.amount* diff_date * x.to_f ** (diff_date -1)
  	end
  end

  def f(x)
  	@f_xn = @flows.inject(0) do |result, flow|
      diff_date = (Date.parse(flow.date.to_s) - Date.parse(@flows[0].date.to_s))/365
  		result += flow.amount * x.to_f ** diff_date 
  	end
  end

  def discount_factor_to_irr (disc_fac)
  	1.0/disc_fac - 1
  end
end
