module Crecto
  module Repo
    class Config
      property database, username, password, hostname, port, uri,
        initial_pool_size, max_pool_size, max_idle_pool_size, checkout_timeout, retry_attempts, retry_delay,
        adapter : Crecto::Adapters::Mysql.class | Crecto::Adapters::SQLite3.class,
        crecto_db : DB::Database?

      def initialize
        @adapter = Crecto::Adapters::Mysql
        @uri = ""
        @database = ""
        @username = ""
        @password = ""
        @hostname = ""
        @initial_pool_size = 1
        @max_pool_size = 0
        @max_idle_pool_size = 1
        @checkout_timeout = 5.0
        @retry_attempts = 1
        @retry_delay = 1.0

        @port = 5432
      end

      def database_url
        return uri unless uri.blank?
        String.build do |io|
          set_url_protocol(io)
          set_url_creds(io)
          set_url_host(io)
          set_url_port(io)
          set_url_db(io)
          set_url_query_string(io)
        end
      end

      def get_connection
        @crecto_db ||= DB.open(database_url).as(DB::Database)
      end

      private def set_url_query_string(io)
        io << "?initial_pool_size=#{@initial_pool_size}"
        io << "&max_pool_size=#{@max_pool_size}"
        io << "&max_idle_pool_size=#{@max_idle_pool_size}"
        io << "&checkout_timeout=#{@checkout_timeout}"
        io << "&retry_attempts=#{@retry_attempts}"
        io << "&retry_delay=#{@retry_delay}"
      end

      private def set_url_db(io)
        if adapter == Crecto::Adapters::SQLite3
          io << "#{database}"
        else
          io << "/#{database}"
        end
      end

      private def set_url_port(io)
        return if adapter == Crecto::Adapters::SQLite3
        io << ":#{port}"
      end

      private def set_url_host(io)
        return if adapter == Crecto::Adapters::SQLite3
        io << hostname
      end

      private def set_url_creds(io)
        return if adapter == Crecto::Adapters::SQLite3
        io << URI.encode_path(username) unless username.empty?
        io << ":#{URI.encode_path(password)}" unless password.empty?
        io << "@" unless username.empty?
      end

      private def set_url_protocol(io)
        if adapter == Crecto::Adapters::Mysql
          io << "mysql://"
        else adapter == Crecto::Adapters::SQLite3
          io << "sqlite3://"
        end
      end
    end
  end
end
