require_relative '../lib/xirr_newton_calculator'
Transaction = Struct.new(:amount, :date)

describe "XirrNewtonCalculator" do
  before :each do
    @flows = [
      Transaction.new(-40, Date.new(2013,10,17)),
      Transaction.new(11, Date.new(2013,11, 1)),
      Transaction.new(11, Date.new(2013,12, 1)),
      Transaction.new(11, Date.new(2014,1, 1)),
      Transaction.new(11, Date.new(2014,2, 1))
    ]
    @init_rate = 0.15
  end

  let(:xirr_calculator) { XirrNewtonCalculator.new(@flows, @init_rate) }

  describe "#calculate" do   
    it "returns 0.789" do 
      expect(xirr_calculator.calculate.round(3)).to eq 0.789
    end

    it "returns correct value" do
      flows = []
      flows << Transaction.new(-213_024_000, Date.new(2013, 10, 17))
      flows << Transaction.new(10_011_582, Date.new(2013, 11, 7))
      flows << Transaction.new(10_021_461, Date.new(2013, 12, 9))
      flows << Transaction.new(10_030_258, Date.new(2014, 1, 7))
      flows << Transaction.new(10_039_489, Date.new(2014, 2, 7))
      flows << Transaction.new(10_048_642, Date.new(2014, 3, 7))
      flows << Transaction.new(10_058_204, Date.new(2014, 4, 7))   
      flows << Transaction.new(10_067_615, Date.new(2014, 5, 7))
      flows << Transaction.new(10_077_241, Date.new(2014, 6, 9)) 
      flows << Transaction.new(10_086_750, Date.new(2014, 7, 7))
      flows << Transaction.new(10_096_787, Date.new(2014, 8, 7))
      flows << Transaction.new(10_106_729, Date.new(2014, 9, 8))
      flows << Transaction.new(10_116_739, Date.new(2014, 10, 7))
      flows << Transaction.new(10_127_085, Date.new(2014, 11, 7))
      flows << Transaction.new(10_137_444, Date.new(2014, 12, 9))
      flows << Transaction.new(10_147_891, Date.new(2015, 1, 7))
      flows << Transaction.new(10_158_638, Date.new(2015, 2, 9))
      flows << Transaction.new(10_169_341, Date.new(2015, 3, 9))
      flows << Transaction.new(10_180_406, Date.new(2015, 4, 7))
      flows << Transaction.new(10_191_572, Date.new(2015, 5, 7))
      flows << Transaction.new(10_202_851, Date.new(2015, 6, 8))
      flows << Transaction.new(10_214_228, Date.new(2015, 7, 7))
      flows << Transaction.new(10_225_830, Date.new(2015, 8, 7)) 
      flows << Transaction.new(10_237_550, Date.new(2015, 9, 7)) 
      flows << Transaction.new(10_249_432, Date.new(2015, 10, 7))
      xirr_calculator = XirrNewtonCalculator.new(flows, 0.15)
      expect(xirr_calculator.calculate.round(6)).to eq 0.141087
    end
  end

  describe "#next_value" do
    it "calls dfdx" do
      xirr_calculator.instance_variable_set(:@f_xn, 1)
      xirr_calculator.should_receive(:dfdx).with(10).and_return(1)
      xirr_calculator.send(:next_value,10)
    end

    it "returns proper value for x=1" do
      xirr_calculator.stub(dfdx: 2)
      xirr_calculator.f_xn = 1
      expect(xirr_calculator.send(:next_value,1)).to eq 0.5
    end
  end

  describe "#f" do 
    it "returns 4 for x = 1" do
      expect(xirr_calculator.send(:f, 1)).to eq 4
    end

    it "returns -9.3 for x = 0.1" do
      expect(xirr_calculator.send(:f, 0.1).round(1)).to eq -9.3
    end
  end

  describe '#dfdx' do
    it "returns 44.9 for x = 0.1" do
      expect(xirr_calculator.send(:dfdx, 0.1).round(1)).to eq 44.9
    end

    it "returns 7.3 for x = 1" do
      expect(xirr_calculator.send(:dfdx, 1).round(1)).to eq 7.3
    end
  end

end
