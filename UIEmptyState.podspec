
Pod::Spec.new do |s|

  s.name         = "UIEmptyState"
  s.version      = "0.1"
  s.summary      = "An empty state view which allows for beautiful iOS apps, written in Swift 3."

  s.description  = <<-DESC
  Empty state view for UITableViewController and UICollectionView, allows building beautiful responsive apps for iOS.
                   DESC

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/luispadron/UIEmptyState"
  s.author             = { "Luis Padron" => "luispadronedu@gmail.com" }
  s.social_media_url   = "https://luispadron.com"
  
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/luispadron/UIEmptyState.git", :tag => "v#{s.version}" }
  s.source_files  = "UIEmptyState", "UIEmptyState/**/*.{h,m}"
end

