Pod::Spec.new do |s|
s.name         = "VWProgressHUD"
s.version      = "0.0.0.5"
s.summary      = "A esay progress hud to use"
s.description  = <<-DESC
A VMProgressHUD
DESC
s.homepage     = "http://www.vaith.xyz"
s.license      = "MIT"
s.author       = { "vaithwee" => "vaithwee@yeah.net" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/vaithwee" }
#s.vendored_frameworks = "Products/*.framework"
s.resources = "VWProgressHUD/*.bundle"
s.source_files  = "VWProgressHUD/**/*.{h,m}"
s.requires_arc = true
s.ios.frameworks = 'Foundation', 'UIKit'
end