Pod::Spec.new do |s|  
    s.name              = 'NKCache'
    s.version           = '1.0.0'
    s.summary           = 'Simple on disk cache, backed by an NSCache in memory.'
    s.homepage          = 'https://github.com/nikksindia/NKCache'

    s.author            = { 'Name' => 'nikksindia@gmail.com' }
    s.license           = { :type => 'MIT', :file => 'License' }

    s.platform          = :ios
    s.source            = { :git => 'https://github.com/nikksindia/NKCache.git', :tag => "v#{s.version}" }
    s.source_files      = "NKCache/*"
    s.swift_version     = "4.0"

    s.ios.deployment_target = '9.0'
   # s.ios.vendored_frameworks = 'NKCache.framework'
end