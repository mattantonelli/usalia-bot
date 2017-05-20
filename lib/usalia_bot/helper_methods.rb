module UsaliaBot
  module HelperMethods
    MENTION = /<@!?#{CLIENT_ID}>/

    def display_name(user)
      user.nickname || user.username
    end
  end
end
