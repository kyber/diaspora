#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class InvitationsController < Devise::InvitationsController
  def update
    begin
      user = User.find_by_invitation_token(params["user"]["invitation_token"])
      user.accept_invitation!(params["user"])
    rescue MongoMapper::DocumentNotValid => e
      user = nil
      flash[:error] = e.message
    end
    if user
      flash[:notice] = I18n.t 'registrations.create.success'
      sign_in_and_redirect(:user, user)
    else
      redirect_to new_user_registration_path
    end
  end
end