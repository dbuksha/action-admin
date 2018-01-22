class ActionAdmin::Devise::SessionsController < ::Devise::SessionsController
    include ActionAdmin::Actionable

    action_title :new, 'Login'

    layout 'admin/devise'
end
