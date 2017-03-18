Pod::Spec.new do |s|
  s.name         = 'SimpleObjectPool'
  s.version      = '1.0.1'
  s.summary      = 'Simple thread-safe object pool in Objective-C'
  s.description  = <<-DESC
                   Simple implementation of a thread-safe object pool.
                   When the pool is empty, it naively creates another
                   object using a block provided.
                   DESC
  s.homepage     = 'https://github.com/paulmelnikow/SimpleObjectPool'
  s.license      = 'Apache 2.0'
  s.author       = { "Paul Melnikow" => "github@paulmelnikow.com" }
  s.source       = { :git => 'https://github.com/paulmelnikow/SimpleObjectPool.git',
                     :tag => "#{s.version}" }

  s.requires_arc = true

  s.source_files = '*.{h,m}'

  # Fix `pod lib lint` in CI.
  # https://github.com/CocoaPods/CocoaPods/issues/6266
  # https://github.com/travis-ci/travis-ci/issues/6737
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.6'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end
