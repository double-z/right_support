require 'spec_helper'
require 'cgi'

describe RightSupport::Net::StringEncoder do
  #Alias for brevity's sake
  ENCODINGS = RightSupport::Net::StringEncoder::ENCODINGS

  before(:all) do
    #Generate some random binary test vectors with varying
    #lengths, 2-1024 bytes
    @strings = []
    (1..10).each do |i|
      s = ''
      i.times { s << rand(256) }
      @strings << s
    end
  end

  context :initialize do
    it 'accepts a glob of encodings' do
      obj = RightSupport::Net::StringEncoder.new(:base64, :url)
      obj.decode(obj.encode('moo')).should == 'moo'
    end

    it 'accepts an Array of encodings' do
      obj = RightSupport::Net::StringEncoder.new([:base64, :url])
      obj.decode(obj.encode('moo')).should == 'moo'
    end

    context 'when unknown encodings are specified' do
      it 'raises ArgumentError' do
        lambda do
          RightSupport::Net::StringEncoder.new(:xyzzy, :foobar)
        end.should raise_error(ArgumentError)
      end
    end
  end

  #Ensure that encodings are symmetrical and commutative by testing round-trip
  #for all combinations.
  (1..ENCODINGS.length).each do |n|
    context "when #{n} encoding(s) are specified" do
      ENCODINGS.combination(n).each do |list|
        it "should round-trip binary strings with #{list.join(', ')}" do
          obj = RightSupport::Net::StringEncoder.new(*list)
          @strings.each do |str|
            obj.decode(obj.encode(str)).should == str
          end
        end
      end
    end
  end
end
