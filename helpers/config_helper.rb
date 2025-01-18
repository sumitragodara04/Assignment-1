require 'selenium-webdriver'
require 'yaml'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'spreadsheet'
require 'browserstack/local'
require 'json'
require 'open-uri'
require 'fileutils'
require 'rest-client'


include Capybara::DSL
include RSpec::Matchers


TASK_ID = (ENV['TASK_ID'] || 0).to_i
CONFIG_NAME = ENV['CONFIG_NAME'] || 'single'
CONFIG = YAML.load(File.read(File.join(File.dirname(File.expand_path('..', __FILE__)), "/config/#{CONFIG_NAME}.config.yml")))
CONFIG['user'] = CONFIG['user']
CONFIG['key'] = CONFIG['key']

def run_session_remote
	@caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])
	url = "https://#{CONFIG['user']}:#{CONFIG['key']}@hub-cloud.browserstack.com/wd/hub"
	capabilities = Selenium::WebDriver::Remote::Capabilities.new
	capabilities['browser_version'] = @caps["browser_version"]
	capabilities['browser'] = @caps["browser"]
	#capabilities['lang'] = 'es'
	capabilities['os'] = @caps["os"]
	capabilities['os_version'] = @caps["os_version"]
	capabilities['name'] = ENV['name']
	capabilities['build'] = ENV['BROWSERSTACK_BUILD_NAME']
	@enable_local = (@caps["browserstack.local"] && @caps["browserstack.local"].to_s == "true")
    capabilities['browserstack.source']= 'rspec:sample-master:v1.1'

    # Code to start browserstack local before start of test
    if @enable_local 
      @bs_local = BrowserStack::Local.new
      bs_local_args = { "key" => CONFIG['key'], "forcelocal" => true }
      @bs_local = @bs_local.start(bs_local_args)
      capabilities["browserstack.local"] = true
    end
    Capybara.default_driver = :browserstack
	Capybara.register_driver :browserstack do |app|
		Capybara::Selenium::Driver.new(app, :browser => :remote,
		:url => url,
		:options => capabilities)	
	end
end

RSpec.configure do |config|

	run_session_remote
	
	config.around(:example) do |example|
		begin
		  example.run
		end
	end
	
	config.after(:each) do
		
		Capybara.current_session.driver.quit
		@bs_local.stop if @enable_local
	end
end
	