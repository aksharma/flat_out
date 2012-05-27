require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#describe "FlatOut" do
#  it "fails" do
##    fail "hey buddy, you should probably rename this file and start specing for real"
#  end
#end

describe "New String" do
  it "should have a blank string of correct length when initialize()" do
    f = FlatOut.new(6)
    f.to_s.should == "      "
  end
end

describe "Reset String without argument" do
  it "should have a blank string of unchanged length when reset()" do
    f = FlatOut.new(6)
    f.reset
    f.to_s.should == "      "
  end
end

describe "Reset String with argument" do
  it "should have a blank string of new length when reset()" do
    f = FlatOut.new(6)
    f.reset(4)
    f.to_s.should == "    "
  end
end

describe "put_alpha exact length" do
  it "should replace the correct space in the right spot" do
    f = FlatOut.new(6)
    f.put_alpha(3,2,"ABC")
    f.to_s.should == " ABC  "
  end
end

describe "put_alpha short length" do
  it "should blank fill the trailing space" do
    f = FlatOut.new(6)
    f.put_alpha(3,2,"AB")
    f.to_s.should == " AB   "
  end
end

describe "put_alpha long length" do
  it "should truncate the extra characters on the right" do
    f = FlatOut.new(6)
    f.put_alpha(3,2,"ABCDE")
    f.to_s.should == " ABC  "
  end
end

describe "put_integer exact length" do
  it "should replace the correct space in the right spot" do
    f = FlatOut.new(6)
    f.put_integer(3,2,123)
    f.to_s.should == " 123  "
  end
end

describe "put_integer short length" do
  it "should zero fill the leading spaces" do
    f = FlatOut.new(6)
    f.put_integer(3,2,12)
    f.to_s.should == " 012  "
  end
end

describe "put_integer long length" do
  it "should truncate the extra characters on the right" do
    f = FlatOut.new(6)
    f.put_integer(3,2,12345)
    f.to_s.should == " 345  "
  end
end

describe "put_digits_only" do
  it "should remove non-digit characters" do
    f = FlatOut.new(11)
    f.put_digits_only(9,2,'01(2)-3ABC4-5^678')
    f.to_s.should == " 012345678 "
  end
end

describe "put_integer_part of an integer" do
  it "should act like put_integer" do
    f = FlatOut.new(6)
    f.put_integer_part(3,2,12345)
    f.to_s.should == " 345  "
  end
end

describe "put_integer_part of a float" do
  it "should remove the decimal part" do
    f = FlatOut.new(6)
    f.put_integer_part(3,2,12345.67)
    f.to_s.should == " 345  "
  end
end

describe "put_decimal_with_point for a float" do
  it "should include the decimal in result for exact size" do
    f = FlatOut.new(12)
    f.put_decimal_with_point(5.3, 2, 12345.678)
    f.to_s.should == " 12345.678  "
  end
end

describe "put_decimal_with_point for a float" do
  it "should truncate the result for smaller size" do
    f = FlatOut.new(12)
    f.put_decimal_with_point(4.2, 2, 12345.643)
    f.to_s.should == " 2345.64    "
  end
end

describe "put_decimal_with_point for a float" do
  it "should truncate the result for smaller size(rounded)" do
    f = FlatOut.new(12)
    f.put_decimal_with_point(4.2, 2, 12345.678)
    f.to_s.should == " 2345.68    "
  end
end

describe "put_decimal_with_point for a float" do
  it "should zero fill both sides" do
    f = FlatOut.new(12)
    f.put_decimal_with_point(4.2, 2, 1.2)
    f.to_s.should == " 0001.20    "
  end
end

describe "put_decimal_no_point for a float" do
  it "should not have a decimal" do
    f = FlatOut.new(12)
    f.put_decimal_no_point(4.2, 2, 1.2)
    f.to_s.should == " 000120     "
  end
end

