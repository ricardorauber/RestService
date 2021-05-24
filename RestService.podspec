Pod::Spec.new do |s|

  s.name                  = 'RestService'
  s.version               = '2.7.0'
  s.ios.deployment_target = '12.4'
  s.swift_versions        = ['5.0', '5.1', '5.2', '5.3', '5.4']
  s.author                = 'Ricardo Rauber Pereira'
  s.license               = 'MIT'
  s.homepage              = 'http://ricardorauber.com'
  s.source                = { :git => 'https://github.com/ricardorauber/RestService.git', :tag => s.version }
  s.summary               = 'A light REST service framework for iOS projects'
  s.pod_target_xcconfig   = { 'ENABLE_TESTABILITY' => 'YES' }
  s.source_files          = 'Classes/**/*'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.requires_app_host = true
    test_spec.source_files      = 'Tests/**/*'

    test_spec.dependency 'Nimble', '9.2.0'
    test_spec.dependency 'OHHTTPStubs/Swift', '9.1.0'
    test_spec.dependency 'Quick', '4.0.0'
  end
end
