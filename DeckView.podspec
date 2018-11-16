#
# Be sure to run `pod lib lint DeckView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DeckView'
  s.version          = '0.1.0'
  s.summary          = 'Tinder like DeckView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Tinder like DeckView with the ability to loop cards'

  s.homepage         = 'https://github.com/umbrellaitcom/DeckView.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AlekseyPakAA' => 'alexey.pak@umbrella-web.com' }
  s.source           = { :git => 'https://github.com/umbrellaitcom/DeckView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version    = '4.2'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DeckView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DeckView' => ['DeckView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
