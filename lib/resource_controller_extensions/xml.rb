module ResourceControllerExtensions::XML::DefaultActions
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      class << self
        alias_method_chain :init_default_actions, :xml
      end
    end
  end

  module ClassMethods
    def init_default_actions_with_xml(klass)
      init_default_actions_without_xml(klass)
      klass.class_eval do
        index.wants.xml { render :xml => collection.to_xml, :status => :ok }
        show.wants.xml { render :xml => object}
        edit.wants.xml { render :xml => object}
        new_action.wants.xml { render :xml => object }

        create.wants.xml { render :xml => object, :status => :created, :location => object }
        create.failure.wants.xml { render :xml => object.errors, :status => :unprocessable_entity }
        destroy.wants.xml { head :ok }
        update.wants.xml { head :ok }
        update.failure.wants.xml { render :xml => object.errors, :status => :unprocessable_entity }
      end
    end
  end
end

config.after_initialize do
  ResourceController::Controller.send :include, ResourceControllerExtensions::XML::DefaultActions
end
