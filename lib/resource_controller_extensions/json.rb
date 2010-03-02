module ResourceControllerExtensions
  module JSON
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        class << self
          alias_method_chain :init_default_actions, :json
        end
      end
    end

    module ClassMethods
      def init_default_actions_with_json(klass)
        init_default_actions_without_json(klass)
        klass.class_eval do
          index.wants.json { render :json => collection.to_json, :status => :ok }
          show.wants.json { render :json => object}
          edit.wants.json { render :json => object}

          create.wants.json { render :json => object, :status => :created, :location => object_url }
          create.failure.wants.json { render :json => {:errors => object.errors.full_messages}, :status => :unprocessable_entity }
          destroy.wants.json { head :ok }
          update.wants.json { head :ok }
          update.failure.wants.json { render :json => {:errors => object.errors.full_messages}, :status => :unprocessable_entity }
        end
      end
    end
  end
end

ResourceController::Controller.send :include, ResourceControllerExtensions::JSON
