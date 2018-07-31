class SQL
  # Account Database connection string
  @@account_connection_params = {
      :adapter => 'tinytds',
      :host => ENV['SQL_host'],
      :port => ENV['SQL_port'],
      :database => ENV['SQL_account_db'],
      :user => ENV['SQL_username'],
      :password => ENV['SQL_password']
  }

  # Shard Database connection string
  @@shard_connection_params = {
      :adapter => 'tinytds',
      :host => ENV['SQL_host'],
      :port => ENV['SQL_port'],
      :database => ENV['SQL_shard_db'],
      :user => ENV['SQL_username'],
      :password => ENV['SQL_password']
  }

  # Shardlog Database connection string
  @@shardlog_connection_params = {
      :adapter => 'tinytds',
      :host => ENV['SQL_host'],
      :port => ENV['SQL_port'],
      :database => ENV['SQL_shardlog_db'],
      :user => ENV['SQL_username'],
      :password => ENV['SQL_password']
  }

  def self.connect_account
    @DB = Sequel.connect(@@account_connection_params)
    @DB
  end

  def self.connect_shard
    @DB = Sequel.connect(@@shard_connection_params)
    @DB
  end

  def self.connect_shardlog
    @DB = Sequel.connect(@@shardlog_connection_params)
    @DB
  end

end