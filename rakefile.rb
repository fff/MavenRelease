require 'yaml'
require 'Nokogiri'
require 'colorize'
require 'highline/import'

require './lib/settings'
require './lib/maven_encryption'

prop = YAML.load_file('./lib/prop.yml')

namespace :release do
  namespace :setup do
    task :test do
      `mvn --version`
      abort 'Unbale to run maven, make sure it has been installed and set in $PATH'.red unless $?.success?
      `ls -l ~/.m2/settings.xml 2>&1`
      abort 'Unable to find settings.xml under ~/.m2, download the settings.xml file from confluence'.red unless $?.success?
    end

    task :master_password do
      security = M2::SettingSecurity.new
      unless security.is_exist? && security.has_master_password?
        master_password = ask('You don\'t have maven master password yet, which is used to encrypt more password.' <<
                                  "\n"<<
                                  'Pls type your master password:'.red) do |q|
          q.echo = false
        end
        say 'Pls wait...'.green
        security.set_master_password!(PasswordEncryption.encrypt_master_password(master_password)).save!
        say "Your maven master password is masked and stored in #{security.path}".green
      else
        say 'Your maven master password is all right'.green
      end
    end

    task :svn_account do
      settings = M2::Settings.new
      unless settings.is_exist? && settings.has_svn_server?

      else
        say 'Your svn server is all right'.green
      end
    end
  end
end