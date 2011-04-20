require "spec_helper"
require "jsonit/builder"

describe Jsonit::Builder, "Building json" do
  specify "a simple object" do
    Jsonit::Builder.new.to_json.should == %|{}|
  end

  specify "a simple object with a string value" do
    Jsonit::Builder.new do |json|
      json.foo "bar"
    end.to_json.should == %|{"foo":"bar"}|
  end

  specify "#to_json" do
    expect { Jsonit::Builder.new.to_json }.to_not raise_error
  end

  specify "a nested object" do
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

  specify "an array" do
    Jsonit::Builder.new do |json|
      json.foo [1, "bar", false, true]
    end.to_json.should == %|{"foo":[1,"bar",false,true]}|
  end

  specify "explicit keys" do
    Jsonit::Builder.new do |json|
      json.set! :foo, "bar"
    end.to_json.should == %|{"foo":"bar"}|
  end
  
  specify "explicit with block" do
    Jsonit::Builder.new do |json|
      json.set! :foo  do
        json.set! :bar, "baz"
      end
    end.to_json.should == %|{"foo":{"bar":"baz"}}|
  end

  specify "collections with a block" do
    Jsonit::Builder.new do |json|
      json.foos ["bar", "baz"] do |item|
        json.value item
      end
      json.foo "bar"
    end.to_json.should == %|{"foos":[{"value":"bar"},{"value":"baz"}],"foo":"bar"}|
  end
end
