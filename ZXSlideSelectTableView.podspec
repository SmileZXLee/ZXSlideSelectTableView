Pod::Spec.new do |s|
s.name         = 'ZXSlideSelectTableView'
s.version      = '1.0.4'
s.summary      = '快速、轻松地实现滑动选择tableView，支持各种自定义显示效果'
s.homepage     = 'https://github.com/SmileZXLee/ZXSlideSelectTableView'
s.license      = 'MIT'
s.authors      = {'李兆祥' => '393727164@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/SmileZXLee/ZXSlideSelectTableView.git', :tag => s.version}
s.source_files = 'ZXSlideSelectTableViewDemo/ZXSlideSelectTableViewDemo/ZXSlideSelectTableView/**/*'
s.requires_arc = true
s.dependency 'ZXTableView'
end