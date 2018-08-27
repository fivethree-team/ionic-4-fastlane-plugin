require 'fastlane/action'
require_relative '../helper/fiv_increment_build_no_helper'

module Fastlane
  module Actions
    class FivIncrementBuildNoAction < Action
      def self.run(params)
        UI.message("The fiv_increment_build_no plugin is working!")
        text = File.read("./config.xml")

        isIos = params[:ios]
        if (isIos)
          app_build_number = sh "echo \"cat //*[local-name()='widget']/@ios-CFBundleVersion\" | xmllint --shell #{params[:pathToConfigXML]}|  awk -F'[=\"]' '!/>/{print $(NF-1)}'"
          puts app_build_number.length

          if(app_build_number.length == 0)
            new_contents = text
                           .gsub(/<widget /, "<widget ios-CFBundleVersion=\"#{1}\" ")
          else
          build_number = app_build_number.to_i +  1
          new_contents = text
                           .gsub(/ios-CFBundleVersion="[0-9]*"/, "ios-CFBundleVersion=\"#{build_number}\"")
          end
        else
          app_build_number = sh "echo \"cat //*[local-name()='widget']/@android-versionCode\" | xmllint --shell #{params[:pathToConfigXML]}|  awk -F'[=\"]' '!/>/{print $(NF-1)}'"
          puts app_build_number.length


          if(app_build_number.length == 0)
            new_contents = text
                           .gsub(/<widget /, "<widget android-versionCode=\"#{1}\" ")
          else
          build_number = app_build_number.to_i +  1
          new_contents = text
                           .gsub(/android-versionCode="[0-9]*"/, "android-versionCode=\"#{build_number}\"")
          end

        end

        puts build_number
      
        File.open("./config.xml", "w") {|file| file.puts new_contents}      
      end

      def self.description
        "fastlane plugin for ionic 4"
      end

      def self.authors
        ["Gary Großgarten"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :ios,
                                  env_name: "FIV_INCREMENT_BUILD_NO_IOS",
                               description: "---",
                                  optional: false,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :pathToConfigXML,
                                  env_name: "FIV_INCREMENT_BUILD_CONFIG",
                               description: "---",
                                  optional: false,
                                  verify_block: proc do | value |
                                    UI.user_error!("Couldnt find config.xml! Please change your path.") unless File.exist?(value)
                                  end  ,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end