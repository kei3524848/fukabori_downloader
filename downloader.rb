require "selenium-webdriver" # (1)
require 'open-uri'
require "fileutils"
driver = Selenium::WebDriver.for :chrome

# ページにアクセス (2)
driver.get "https://fukabori.fm/"

# ディレクトリ作成 (3)
directoryName = "C:\\fukabori"
unless File.directory?(directoryName) 
  FileUtils.mkdir_p(directoryName)
end

# ページ内にあるリンク要素を取得 (4)
elements = driver.find_elements(:xpath, '/html/body/main/div/div/article[*]/h1/a')

# リンク先のURLのリスト作成 (5)
urls = elements.map {|element| element.attribute('href') }
# ダウンロード処理 (6)
urls.each do |url|
  driver.get(url)
  urlElement = driver.find_element(:xpath, '/html/body/main/div/article/section/p[2]/small/a')
  mp3Url = urlElement.attribute('href')

  tmpfile = URI.parse(mp3Url).open # (6)

  titleNameElm = driver.find_element(:xpath, '/html/body/main/div/article/header/h1/a')
  titleName = titleNameElm.text.tr('/', '')
  fileName = directoryName + "\\" + titleName + ".mp3"
  FileUtils.mv tmpfile.path, fileName  # (7)
  tmpfile.close
end