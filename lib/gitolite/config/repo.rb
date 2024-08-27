# frozen_string_literal: true

module Gitolite
  class Config

    # Represents a repo inside the gitolite configuration.  The name, permissions, and git config
    # options are all encapsulated in this class
    class Repo

      ALLOWED_PERMISSIONS = /-|C|R|RW\+?(?:C?D?|D?C?)M?/.freeze

      attr_accessor :permissions, :name, :config, :options, :owner, :description

      # Store the perm hash in a lambda since we have to create a new one on every deny rule
      # The perm hash is stored as a 2D hash, with individual permissions being the first
      # degree and individual refexes being the second degree.  Both Hashes must respect order
      #
      def initialize(name)
        @perm_hash_lambda = -> { Hash.new { |k, v| k[v] = Hash.new { |k2, v2| k2[v2] = [] } } }
        @permissions = [@perm_hash_lambda.call]

        @name    = name
        @config  = {} # git config
        @options = {} # gitolite config
      end


      def clean_permissions
        @permissions = [@perm_hash_lambda.call]
      end


      def add_permission(perm, refex = '', *users)
        if ALLOWED_PERMISSIONS.match?(perm)
          # Handle deny rules
          if perm == '-'
            @permissions.push(@perm_hash_lambda.call)
          end

          @permissions.last[perm][refex].concat users.flatten
          @permissions.last[perm][refex].uniq!
        else
          raise InvalidPermissionError, "#{perm} is not in the allowed list of permissions!"
        end
      end


      def set_git_config(key, value)
        @config[key] = value
      end


      def unset_git_config(key)
        @config.delete(key)
      end


      def set_gitolite_option(key, value)
        @options[key] = value
      end


      def unset_gitolite_option(key)
        @options.delete(key)
      end


      # rubocop:disable Metrics/AbcSize
      def to_s
        repo = "repo    #{@name}\n"

        @permissions.each do |perm_hash|
          perm_hash.each do |perm, list|
            list.each do |refex, users|
              repo += '  ' + perm.ljust(6) + refex.ljust(25) + '= ' + users.join(' ') + "\n"
            end
          end
        end

        @config.each do |k, v|
          repo += '  config ' + k + ' = ' + v.to_s + "\n"
        end

        @options.each do |k, v|
          repo += '  option ' + k + ' = ' + v.to_s + "\n"
        end

        repo
      end
      # rubocop:enable Metrics/AbcSize


      def gitweb_description
        return nil if @description.nil?

        desc = "#{@name} "
        desc += "\"#{@owner}\" " unless @owner.nil?
        desc += "= \"#{@description}\""
        desc
      end


      # Gets raised if a permission that isn't in the allowed
      # list is passed in
      class InvalidPermissionError < ArgumentError
      end

    end

  end
end
