require 'postgres'
#require 'postgres_connection'

HOST = 'localhost'
PORT = 5432
DB_NAME = 'RMSC'
USER = 'dms'
PASSWORD = 'j0rdan32'

class PostgresConnection

  def connection
    @connection ||= PGconn.connect(HOST, PORT, '', '', DB_NAME, USER, PASSWORD)
  end

  def exec(sql)
    connection.exec sql
  end

  def close
    @connection.close if @connection
    @connection = nil
  end

  def clear_mysql_database
    puts "Clearing the database"
    BuyerRegistration.delete_all
    ExhibitorAssociateLine.delete_all
    ExhibitorAssociate.delete_all
    Buyer.delete_all
    ExhibitorRegistration.delete_all
    ExhibitorLine.delete_all
    Exhibitor.delete_all
    Store.delete_all
    Show.delete_all
    Coordinator.delete_all
    Venue.delete_all
    puts "Done clearing the database"
  end

end

