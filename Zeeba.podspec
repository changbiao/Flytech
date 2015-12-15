Pod::Spec.new do |s|
  s.name     = 'Zeeba'
  s.version  = '0.0.1'
  s.license  = { :type => 'Commercial' }
  s.homepage = 'https://github.com/Wallmob/Zeeba'
  s.authors  = { 'Rasmus Taulborg Hummelmose' => 'rasmus@hummelmose.dk' }
  s.summary  = 'Objective-C SDK for Zeeba stands.'
  s.source   = { :git => 'https://github.com/Wallmob/Zeeba.git', :tag => "#{s.version}" }
  s.source_files = 'Source/**/*.{h,m}', 'Umbrella/**/*.{h,m}'
  s.requires_arc = true
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
end
