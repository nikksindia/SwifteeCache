Pod::Spec.new do |s|  
    s.name              = 'SwifteeCache'
    s.version           = '1.1.0'
    s.summary           = 'Simple on disk cache, backed by an NSCache in memory.'
    s.homepage          = 'https://github.com/nikksindia/SwifteeCache'

    s.author            = { 'Name' => 'nikksindia@gmail.com' }
    s.license           = { :type => 'MIT', :file => 'License' }

    s.platform          = :ios
    s.source            = { :git => 'https://github.com/nikksindia/SwifteeCache.git', :tag => "v#{s.version}" }
    s.source_files      = "SwifteeCache/*"
    s.exclude_files     = "SwifteeCache/*.plist"
    s.swift_version     = "5.1"

    s.ios.deployment_target = '10.0'
   # s.ios.vendored_frameworks = 'SwifteeCache.framework'
end
