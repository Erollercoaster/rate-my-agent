require 'webdrivers'
require 'selenium-webdriver'

def check_website(url)
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-gpu')
  options.add_argument('--user-agent=')

  Webdrivers::Chromedriver.required_version = nil
  Webdrivers::Chromedriver.update

  driver = Selenium::WebDriver.for :chrome, options: options
  driver.get url

  agent_found = false

  begin
    agent_element = driver.find_element(css: 'div[class="agent-card"]')
    agent_found = agent_element.text.include?('John Doe')
  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    puts "Error: #{e.message}"
  end

  driver.quit

  return agent_found
end

def log_result(result, log_file)
  File.open(log_file, 'a') { |f| f.puts "Agent found: #{result} at #{Time.now}" }
end

url = 'https://www.rate-my-agent.com'
log_file = 'check_rate_my_agent.log'

result = check_website(url)
log_result(result, log_file)
