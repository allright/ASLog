Pod::Spec.new do |s|
  s.name         = "ASLog"
  s.version      = "1.0.2"
  s.summary      = "iOS Logging"
  s.description  = <<-DESC
    Simplest Swift logging framework.
                   DESC
  s.homepage     = "https://www.linkedin.com/in/andrey-syvrachev-279ba640/"
  s.author       = { "Andrey Syvrachev" => "andrey.syvrachev@gmail.com" }

  s.swift_version = '4.0'
  s.platform     = :ios, "10.0"
  s.source       = { :git => 'https://github.com/allright/ASLog.git' ,:tag => '1.0.2' }
  s.source_files = "**/*.swift"
  s.license      = "LICENSE" 

end
