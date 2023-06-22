module EHR
  module JamTangan
    class Client < JamTanganAdapter
      def profile
        visit "#{base_url}/account"
        sleep 2

        OpenStruct.new(
          name: first_name,
          last_name: last_name,
          point: point
        )
      end

      private

      def first_name
        'First name'
      end

      def last_name
        'Last name'
      end

      def point
        wait_for_find_element(page, 'a[data-testid="link-mw-point"]')

        find_all('a[data-testid="link-mw-point"] p').last.text.gsub(/[^\d]/, '')
      end
    end
  end
end
