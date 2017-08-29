Pod::Spec.new do |s|
  s.name             = 'GRCalendar'
  s.version          = '0.1.0'
  s.summary          = 'A simple calendar view that allow to select date'

  s.homepage         = 'https://github.com/maciej-matuszewski/GRCalendar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gr3mlin106' => 'maciej.matuszewski@me.com' }
  s.source           = { :git => 'https://github.com/maciej-matuszewski/GRCalendar.git', :tag => s.version.to_s }

#  s.ios.deployment_target = '8.3'
  s.osx.deployment_target  = '10.12'

  s.source_files = 'GRCalendar/Classes/Common/**/*'
#  s.ios.source_files   = 'GRCalendar/Classes/iOS/**/*'
  s.osx.source_files   = 'GRCalendar/Classes/macOS/**/*'

#  s.ios.framework  = 'UIKit'
  s.osx.framework  = 'AppKit'
end
