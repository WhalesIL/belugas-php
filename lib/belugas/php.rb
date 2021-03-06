require 'thor'
require 'json'
require 'belugas/php/dispatcher'
require 'belugas/php/localizer'
require 'belugas/php/dependency_constructor'
require 'rescuer'

module Belugas
  module Php
    class Sonar < Thor
      package_name 'belugas-php'

      desc 'analyze --directory-path=/app/code', 'PHP feature detection JSON'
      method_option 'directory-path', type: :string, default: '/code/', required: false, aliases: '-p'

      def analyze
        rescuer = Rescuer.new
        begin
          Belugas::Php::Dispatcher.new(dependency_constructor).render
        rescue Exception => e
          rescuer.ping e
          raise e
        end
      end

      private

      def localizer
        @localizer ||= Belugas::Php::Localizer.new(options['directory-path'])
      end

      def dependency_constructor
        Belugas::Php::DependencyConstructor.new(localizer.composer_path, localizer.database_path)
      end
    end
  end
end

require 'belugas/php/version'
