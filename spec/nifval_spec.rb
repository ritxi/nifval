require 'spec_helper'

require 'models/nif'

describe NifValidator do
  def nif_validity nif, ok
    test = Nif.new
    test.testfield = nif
    test.valid?.should == ok
  end

  # Correct NIFs
  context "when we check valid NIFs" do
    it "should return OK" do
      nif_validity "00000000T", true
    end
  end

  # Invalid NIFs
  context "when we check invalid NIFs" do
    it "should return ERROR" do
      nif_validity "12345678T", false
    end
  end

  # Correct CIFs
  context "when we check valid CIFs" do
    it "should return OK when ended with number" do
      nif_validity "A12345674", true
    end

    it "should return OK when ended with character" do
      nif_validity "R2345678C", true
    end
  end

  context "when we check invalid CIFs" do
    it "should return ERROR when ended with number" do
      nif_validity "A12345675", false
    end

    it "should return OK when ended with character" do
      nif_validity "R2345678D", false
    end
  end

  # Correct NIEs
  context "when we check valid NIEs" do
    it "should return OK" do
      nif_validity "X1230123Z", true
    end
  end

  # Incorrect NIEs
  context "when we check invalid NIEs" do
    it "should return ERROR" do
      nif_validity "X1230123F", false
    end
  end

  # Good format
  context "when we check alternatively-formatted strings" do
    # Accept with length < 9
    it "should return OK" do
      nif_validity "T", true
    end

    # Accept lowercase
    it "should return OK" do
      nif_validity "00000000t", true
    end
  end

  # Bad format
  context "when we check for badly-formatted strings" do
    it "should return ERROR" do
      nif_validity nil, false
    end

    it "should return ERROR" do
      nif_validity "cucamonga", false
    end

    it "should return ERROR" do
      nif_validity "0000 0000 T", false
    end

    it "should return ERROR" do
      nif_validity "123A123AA", false
    end

    it "should return ERROR" do
      nif_validity "123456753215X1230123Z", false
    end
  end

end
