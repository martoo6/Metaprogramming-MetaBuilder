class ValidationException < Exception; end

class GenericBuilder
  attr_accessor :target_class, :properties, :validations, :condition_actions

  def build
    target = target_class.new
    properties.each do |var|
      property_value = self.instance_variable_get('@'+var.to_s)
      target.send(:instance_variable_set, '@'+var.to_s, property_value)
    end
    if(!validations.nil?)
      validations.each do |validation|
        if(!target.instance_eval(&validation)) then raise Exception end
      end
    end
    if(!condition_actions.nil?)
      condition_actions.each { |condition_action|
        if(target.instance_eval(&condition_action.condition))
          value = target.instance_eval(&condition_action.action)
          target.send(:instance_variable_set, '@'+condition_action.property_name.to_s, value)
        end
      }
    end
    target
  end
end