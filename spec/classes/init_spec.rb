require 'spec_helper'

describe 'autofs' do
  platforms = {
    'RedHat' =>
      {
        :osfamily     => 'RedHat',
        :package_name => 'hp-health',
        :service_name => 'hp-health',
      },
    'Suse' =>
      {
        :osfamily     => 'Suse',
        :package_name => 'hp-health',
        :service_name => 'hp-health',
      },
    'Debian' =>
      {
        :osfamily     => 'Debian',
        :package_name => 'hp-health',
        :service_name => 'hp-health',
      },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do
        let :facts do
          {
            :osfamily   => v[:osfamily],
          }
        end

        it {
          should contain_package("#{v[:package_name]}").with({
            'ensure' => 'present',
            'name'   => v[:package_name],
          })
        }

        it {
          should contain_service("#{v[:service_name]}").with({
            'ensure'    => true,
            'enable'    => true,
            'name'      => v[:service_name],
          })
        }

      end
    end
  end

  describe 'with optional parameters set' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do
        let :facts do
          {
            :osfamily          => v[:osfamily],
          }
        end

      end
    end
  end
end

