require 'cgi'
require 'timeout'
require 'capybara'
require 'capybara/dsl'

class EHR::BaseAdapter
  include Capybara::DSL

  def self.transaction_session(service = nil)
    start_time = Time.now
    Capybara.using_session SecureRandom.uuid do
      result = yield
      current_scope.session.quit

      result
    rescue StandardError => e
      current_scope.session.quit

      raise e
    end
  end

  def initialize
    Capybara.register_driver :selenium_chrome_headless do |app|
      client = Selenium::WebDriver::Remote::Http::Default.new

      browser_options =
        ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
          opts.page_load_strategy = :eager

          opts.args << '--no-sandbox'
          opts.args << '--disable-extensions'
          opts.args << '--disable-dev-shm-usage'

          opts.args << '--headless' unless Rails.env.development?
          opts.args << '--disable-site-isolation-trials'
          opts.args << 'window-size=4920,4080'
          opts.args <<
            '--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36'
        end

      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        capabilities: browser_options,
        http_client: client
      )
    end

    Capybara.default_driver = :selenium_chrome_headless
  end

  class << self
    def action_methods
      @action_methods ||=
        begin
          methods =
            public_instance_methods - Class.public_instance_methods(true)
          methods.to_set
        end
    end

    def respond_to_missing?(method, include_all = false)
      action_methods.include?(method) || super
    end

    def method_missing(method_name, *args)
      if action_methods.include?(method_name)
        new.send(method_name, *args)
      else
        super
      end
    end
  end

  def base_url
    raise 'MISSING_BASE_URL'
  end

  def wait_for_find_element(page, el_class)
    Timeout.timeout(10) { sleep 0.1 until page.has_css?(el_class) }
  end

  def wait_for_click_element(page, el_class, text: nil)
    Timeout.timeout(10) { sleep 0.1 until page.has_css?(el_class, text: text) }

    page.find(el_class, text: text, match: :first).click
    sleep 2
  end
end
