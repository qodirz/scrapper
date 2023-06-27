module EHR
  module JamTangan
    class Auth < JamTanganAdapter
      def log_in(username:, password:)
        visit "#{base_url}/login"

        sleep 2
        find('input[name="username"]').set(username)
        find('input[name="password"]').set(password)
        sleep 1
        find('.login-form-container form button').click
      end

      def log_out
        visit base_url
        sleep 2

        find('.qa-user-button').click
        find('.ic-logout').click
        find('button[data-testid="confirm-logout-cancel"]').click
      end
    end
  end
end
