Pod::Spec.new do |s|
s.name         = "VMProgressHUD"
s.version      = "0.0.2"
s.summary      = "A esay progress hud to use"
s.description  = <<-DESC
A VMProgressHUD
DESC
s.homepage     = "http://www.vaith.xyz"
s.license      = "MIT"
s.author       = { "vaithwee" => "vaithwee@yeah.net" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/vaithwee" }
s.vendored_frameworks = "Products/*.framework"
s.requires_arc = true
end