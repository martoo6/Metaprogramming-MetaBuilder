require_relative 'Builder.rb'

class Condition_action
  attr_accessor :condition, :action, :property_name

  def initialize(property_name, condition, action)
    @property_name = property_name
    @condition = condition
    @action = action
  end
end

class Metabuilder
  attr_accessor :target_clazz, :properties, :validations ,:condition_actions

  def initialize
    @properties=[]
    @validations=[]
    @condition_actions=[]
  end

  def set_target_class(target_class)
    @target_clazz=target_class
    self
  end

  def add_property(property)
    @properties << property
    self
  end

  def property(property)
    @properties << property
  end

  def target_class(target_class)
    @target_clazz=target_class
  end

  def validate(&block)
    validations << block
  end

  def behave_when(property, condition, action)
    @properties << property
    condition_action = Condition_action.new(property,condition, action)
    @condition_actions << condition_action
  end

  def build
    builder = GenericBuilder.new
    builder.target_class = target_clazz
    builder.properties = properties
    builder.validations = validations
    builder.condition_actions = condition_actions
    properties.each do |property|
      builder.singleton_class.send(:attr_accessor, property)
    end
    builder
  end

  def self.build(&block)
    meta = Metabuilder.new
    meta.instance_eval(&block)
    meta.build
  end
end