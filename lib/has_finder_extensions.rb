module HasFinder
  # Provides Model.paginate(options={}) to allow
  # the paginating_find plugin to be used with the has_finder plugin.
  #
  # Usage:
  #   acts_as_paginated
  #   acts_as_paginated :page => 2, size => 10
  #
  # Install:
  #   Save this file as lib/has_finder_extensions.rb and require 'has_finder_extensions'
  #   in environment.rb.
  module PaginatingFind #:nodoc:

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_paginated(options={ :page => 1, :size => 20})
        cattr_accessor :paginate_defaults
        self.paginate_defaults = options

        self.class_eval do
          extend HasFinder::PaginatingFind::SingletonMethods
        end
      end
    end

    module SingletonMethods
      def paginate(args={})
        options = self.paginate_defaults.clone
        options[:page] = args[:page].to_i if args[:page]
        options[:size] = args[:size].to_i if args[:size]
        find(:all, :page => { :size => options[:size], :current => options[:page], :first => 1 })
      end
    end
  end

  # Provides Model.chain_finders(finders={}) to enable dynamic chaining of
  # HasFinder finders.
  #
  # Usage:
  #   chains_finders
  #
  #   Model.chain_finders(:after => Date.today, :belonging_to => User.current_user)
  #
  # Install:
  #   Save this file as lib/has_finder_extensions.rb and require 'has_finder_extensions'
  #   in environment.rb.
  module ChainsFinders #:nodoc:

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      def chains_finders(options={})
        self.class_eval do
          extend HasFinder::ChainsFinders::SingletonMethods
        end
      end
    end

    module SingletonMethods
      def chain_finders(finders={})
        target = self
        finders.each do |name, args|
          target = target.send name, args
        end
        target
      end
    end
  end
end

ActiveRecord::Base.send(:include, HasFinder::PaginatingFind)
ActiveRecord::Base.send(:include, HasFinder::ChainsFinders)