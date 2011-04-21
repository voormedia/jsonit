require "spec_helper"
require "tilt"

require "jsonit"

describe "Jsonit Tilt Support" do
  it 'is registered for ".jsonit" files' do
    Tilt['test.jsonit'].should == ::Tilt::JsonitTemplate
    Tilt['test.json.jsonit'].should == ::Tilt::JsonitTemplate
  end

  specify "loading and evaluating templates on #render" do
    template = Tilt::JsonitTemplate.new { |t| "json.foo 'bar'" }
    template.render.should == %|{"foo":"bar"}|
  end

  specify "can be rendered more than once" do
    template = Tilt::JsonitTemplate.new { |t| "json.foo 'bar'" }
    3.times { template.render.should == %|{"foo":"bar"}| }
  end

  specify "passing locals" do
    template = Tilt::JsonitTemplate.new { 'json.foo name' }
    template.render(Object.new, :name => 'Joe').should == %|{"foo":"Joe"}|
  end
end

