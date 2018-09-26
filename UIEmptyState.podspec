
Pod::Spec.new do |s|

  s.name         = "UIEmptyState"
  s.version      = "4.0.0"
  s.summary      = "An empty state control to give visually appealing context when building iOS applications."
  s.description  = <<-DESC
  s.swift_version = '4.2'
  Empty state control which gives context with either a message, image, and buttons to the user when ever there is a reason the state is empty.
  Easily conform to the protocol to provide a visually appealing view to an empty table view controller.
                   DESC
  s.homepage     = "https://github.com/luispadron/UIEmptyState"
  s.screenshots  = "https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen1.jpg", "https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen2.jpg", "https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen3.jpg"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Luis Padron" => "luis@luispadron.com" }
  s.social_media_url   = "https://luispadron.com"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/luispadron/UIEmptyState.git", :tag => "v#{s.version}" }
  s.source_files  = "src/UIEmptyState", "src/UIEmptyState/**/*.{h,m}"
end

