module EHR
  module JamTangan
    class Auth < JamTanganAdapter
      def log_in(username:, password:)
        visit base_url

        sleep 2
        if page.has_css?('#moe-push-div')
          find('.ng-binding', text: 'Nanti Saja').click
        end

        wait_for_click_element(page, '#login-button')
        find('input[name="username"]').set('rails303@yahoo.com')
        find('input[name="password"]').set('123123123A!')
        find('.qa-login-button').click
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
