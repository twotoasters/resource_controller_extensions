module ResourceControllerExtensions::FBML::DefaultActions
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      class << self
        alias_method_chain :init_default_actions, :fbml
      end
    end
  end

  module ClassMethods

    def init_default_actions_with_fbml(klass)
      init_default_actions_without_fbml(klass)
      klass.class_eval do
        index.wants.fbml
        new_action.wants.fbml
        edit.wants.fbml

        show do
          wants.fbml

          failure.wants.fbml { render :text => "Member object not found." }
        end

        create do
          flash "Successfully created!"
          wants.fbml { redirect_to object_url }

          failure.wants.fbml { render :action => "new" }
        end

        update do
          flash "Successfully updated!"
          wants.fbml { redirect_to object_url }

          failure.wants.fbml { render :action => "edit" }
        end

        destroy do
          flash "Successfully removed!"
          wants.fbml { redirect_to collection_url }
          failure.wants.fbml { redirect_to object_url }
        end
      end
    end

  end
end

config.after_initialize do
  ResourceController::Controller.send :include, ResourceControllerExtensions::FBML::DefaultActions
end
