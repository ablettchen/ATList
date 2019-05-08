#
# Be sure to run `pod lib lint ATList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATList'
  s.version          = '0.1.5'
  s.summary          = '快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView'
  s.homepage         = 'https://github.com/ablettchen/ATList'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ablettchen' => 'ablettchen@gmail.com' }
  s.social_media_url = 'https://weibo.com/ablettchen'
  s.platform         = :ios, '8.0'
  s.source           = { :git => 'https://github.com/ablettchen/ATList.git', :tag => s.version.to_s }
  s.source_files     = 'ATList/**/*.{h,m}'
  #s.resource         = 'ATList/ATList.bundle'
  s.requires_arc     = true
  
  s.dependency 'MJRefresh'
  s.dependency 'ATBlank'
  
end
