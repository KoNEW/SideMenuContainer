Pod::Spec.new do |s|
  s.name             = "SideMenuContainer"
  s.version          = "1.0.0"
  s.summary          = "A short description of SideMenuContainer."
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/KoNEW/SideMenuContainer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Владимир Конев" => "konev.vn@gmail.com" }
  s.source           = { :git => "https://github.com/KoNEW/SideMenuContainer.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SideMenuContainer' => ['Pod/Assets/*.{png,nib}']
  }
  s.resources = 'Pod/Assets/*.{png,nib}'
  s.dependency 'Cartography'
end
