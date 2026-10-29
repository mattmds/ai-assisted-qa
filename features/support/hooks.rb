# frozen_string_literal: true

Before do
  @driver = DriverFactory.build
  @wait = Selenium::WebDriver::Wait.new(
    timeout: 10,
    ignore: [
      Selenium::WebDriver::Error::NoSuchElementError,
      Selenium::WebDriver::Error::StaleElementReferenceError
    ]
  )
end

After do |scenario|
  if scenario.failed? && @driver
    FileUtils.mkdir_p(Config.reports_dir)
    filename = scenario.name.gsub(/\W+/, "_")[0, 80]
    @driver.save_screenshot(File.join(Config.reports_dir, "#{filename}.png"))
  end
ensure
  @driver&.quit
end
