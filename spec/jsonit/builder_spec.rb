require "spec_helper"
require "jsonit/builder"

describe Jsonit::Builder do

  describe ".new" do
    it 'represents an empty object' do
      Jsonit::Builder.new.to_json.should == %|{}|
    end

    it 'sets the root scope if provided' do
      scope = { :foo => "bar" }
      Jsonit::Builder.new(scope).to_json.should == %|{"foo":"bar"}|
    end

    it 'evaluates the passed block' do
      obj = mock()
      obj.expects(:ping).once
      Jsonit::Builder.new do |json|
        obj.ping
      end.to_json
    end
  end

  describe "#set!" do
    let(:json) { Jsonit::Builder.new }

    it 'returns an instance of self' do
      json.set!.should be_a Jsonit::Builder
    end

    it 'sets a key value pair' do
      json.set!(:foo, "bar").to_json.should == %|{"foo":"bar"}|
    end

    it 'sets value to null if not provided' do
      json.set!(:foo).to_json.should == %|{"foo":null}|
    end

    it 'sets value to an object if block is provided' do
      json.set!(:foo) { }.to_json.should == %|{"foo":{}}|
    end

    it 'sets values on nested object within block' do
      json.set!(:foo) { json.set!(:a, "b") }.should == %|{"foo":{"a":"b"}}|
    end
  end

  describe "#object!" do
    let(:json) { Jsonit::Builder.new }

    it 'creates an object' do
      json.object!(:foo) { }.to_json.should == %|{"foo":{}}|
    end

    it 'passes value to the block' do
      value = mock()
      value.expects(:ping)
      json.object!(:foo, value) { |val| val.ping }
    end

    it 'sets scope to the object' do
      json.object!(:foo) { json.set!(:bar, "baz") }.to_json.should == %|{"foo":{"bar":"baz"}}|
    end

    it 'continues an object with same key' do
      json.object!(:foo) { json.set!(:a, "b") }
      json.object!(:foo) { json.set!(:c, "d") }
      json.to_json.should == %|{"foo":{"a":"b","c":"d"}}|
    end
  end

  describe "#array!" do
    let(:json) { Jsonit::Builder.new }

    it 'creates an array' do
      json.array!(:foo).to_json.should == %|{"foo":[]}|
    end

    it 'sets value to array if no block is given' do
      json.array!(:foo, ["a", 1, false]).to_json.should == %|{"foo":["a",1,false]}|
    end

    it 'executes block for each entry in the collection' do
      obj1, obj2 = mock(), mock()
      obj1.expects(:ping).once
      obj2.expects(:ping).once

      json.array!(:foo, [obj1, obj2]) { |obj| obj.ping }.to_json
    end

    it 'creates an object for each entry' do
      json.array!(:foo, [1,"a"]) { |val| json.set!(:val, val) }.to_json.should == %|{"foo":[{"val":1},{"val":"a"}]}|
    end
  end

  describe "DSL" do
    it "can nest multiple levels" do
      Jsonit::Builder.new do |json|
        json.foo do
          json.bar "baz"
        end

        json.alpha do
          json.bravo "charlie"
          json.delta "echo"

          json.foxtrot do
            json.golf "hotel"
          end
        end
      end.to_json.should == %|{"foo":{"bar":"baz"},"alpha":{"bravo":"charlie","delta":"echo","foxtrot":{"golf":"hotel"}}}|
    end
  end
end
