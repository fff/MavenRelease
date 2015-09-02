require 'yaml'
require 'Nokogiri'
require './lib/settings'

prop = YAML.load_file('./lib/prop.yml')

namespace :release do
  namespace :setup do
    task :svn_account do
      master_password_file = File.join(Dir.home, '.m2', 'settings-security.xml')
      master_password_file2 = File.join(Dir.home, '.m2', 'settings-security2.xml')
      setting_file = File.join(Dir.home, '.m2', 'settings.xml')
      setting_file2 = File.join(Dir.home, '.m2', 'settings2.xml')

      security_xml = Nokogiri::XML(File.open(master_password_file))
      puts security_xml.xpath('//settingsSecurity/master/text()')

      masked_master_password='{somehting}'
      in_xml = Nokogiri::XML <<-XML
<settingsSecurity>
  <master>#{masked_master_password}</master>
</settingsSecurity>
      XML

      puts in_xml.to_xml
      File.open(master_password_file2, 'w').write(in_xml.to_xml)

      setting_xml = Nokogiri::XML(File.open(setting_file))
      puts setting_xml.xpath("//xmlns:servers//xmlns:id[text()='#{prop['svn']['host']}:#{prop['svn']['port']}']")

      settings_xml_new = M2::Settings.new(File.join(Dir.home, '.m2', 'settings2.xml'))
      puts settings_xml_new.has_svn_server?
      unless settings_xml_new.has_svn_server?
        settings_xml_new.set_svn_server('fff', Time.now)
        puts settings_xml_new.save
      end

      setting_security_new = M2::SettingSecurity.new(File.join(Dir.home, '.m2', 'settings-security2.xml'))
      puts setting_security_new.has_master_password?
      unless setting_security_new.has_master_password?
        setting_security_new.set_master_password Time.now
        puts setting_security_new.save
      end
    end
  end
end