require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

describe "reset with different base" do
  it "should reset to new size with new base" do
    f = FlatOut.new(6, :base => 2)
    f.reset(5, :base => 1)
    f.put(3,2,123)
    f.to_s.should == " 123 "
  end
end

describe "put exact length alpha" do
  it "should replace the correct space in the right spot" do
    f = FlatOut.new(6)
    f.put(3,2,"ABC")
    f.to_s.should == " ABC  "
  end
end

describe "put exact length alpha with fld_pos_len format" do
  it "should replace the correct space in the right spot" do
    f = FlatOut.new(6, :format => :fld_pos_len)
    f.put("ABC",2,3)
    f.to_s.should == " ABC  "
  end
end

describe "put short length alpha" do
  it "should blank fill the trailing space" do
    f = FlatOut.new(6)
    f.put(3,2,"AB")
    f.to_s.should == " AB   "
  end
end

describe "put long length alpha" do
  it "should truncate the extra characters on the right" do
    f = FlatOut.new(6)
    f.put(3,2,"ABCDE")
    f.to_s.should == " ABC  "
  end
end

describe "put exact length integer with default base 1" do
  it "should replace the correct space in the right spot using base 1" do
    f = FlatOut.new(6)
    f.put(3,2,123)
    f.to_s.should == " 123  "
  end
end

describe "put exact length integer with base 0" do
  it "should replace the correct space in the right spot using base 0" do
    f = FlatOut.new(6, :base => 0)
    f.put(3,2,123)
    f.to_s.should == "  123 "
  end
end

describe "put short length integer" do
  it "should zero fill the leading spaces" do
    f = FlatOut.new(6)
    f.put(3,2,12)
    f.to_s.should == " 012  "
  end
end

describe "put long length integer" do
  it "should truncate the extra most dignificant digits on left" do
    f = FlatOut.new(6)
    f.put(3,2,12345)
    f.to_s.should == " 345  "
  end
end

describe "put float with short length integer only" do
  it "should remove the decimal part and truncate the left digits" do
    f = FlatOut.new(6)
    f.put(3,2,12345.67)
    f.to_s.should == " 345  "
  end
end

describe "put float with decimal part and full length" do
  it "should include the decimal in result for exact size" do
    f = FlatOut.new(12)
    f.put(5.3, 2, 12345.678)
    f.to_s.should == " 12345.678  "
  end
end

describe "put float with decimal part with shorter length on both ends" do
  it "should truncate the result for smaller size" do
    f = FlatOut.new(12)
    f.put(4.2, 2, 12345.643)
    f.to_s.should == " 2345.64    "
  end
end

describe "put float with decimal part with shorter length on both ends with rounding" do
  it "should truncate the result for smaller size(rounded)" do
    f = FlatOut.new(12)
    f.put(4.2, 2, 12345.678)
    f.to_s.should == " 2345.68    "
  end
end

describe "put float with longer length on both ends" do
  it "should zero fill both sides" do
    f = FlatOut.new(12)
    f.put(4.2, 2, 1.2)
    f.to_s.should == " 0001.20    "
  end
end

describe "put float with negative length" do
  it "should not have a decimal" do
    f = FlatOut.new(12)
    f.put(-4.2, 2, 1.2)
    f.to_s.should == " 000120     "
  end
end

describe "put with a template" do
  it "should put multiple fields" do
    f = FlatOut.new(18, :template => [[5,1],[5,6],[4.2,11]])
    val = ['ABCD',10,10.23]
    f.put(val)
    f.to_s.should == 'ABCD 000100010.23 '
  end
end

describe "digits_only" do
  it "should remove non-digit characters" do
    FlatOut.digits_only('01(2)-3ABC4-5^678').should == "012345678"
  end
end

describe "phone_squeeze" do
  it "should remove phone punctuation characters" do
    FlatOut.phone_squeeze('(800) 555-1212').should == "8005551212"
  end
end

describe "phone_squeeze" do
  it "should remove phone punctuation characters and maintain extensions" do
    FlatOut.phone_squeeze('(800) 555-1212 Ext 234').should == "8005551212Ext234"
  end
end

describe "phone_squeeze" do
  it "should remove phone punctuation characters and maintain extensions" do
    FlatOut.phone_squeeze('(800) GOT-MILK').should == "800GOTMILK"
  end
end

