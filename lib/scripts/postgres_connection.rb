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
#  AssociateLine.delete_all
#  AssociateRoom.delete_all
#  Associate.delete_all
#  BuyerAttendance.delete_all
#  Buyer.delete_all
    ExhibitorRegistration.delete_all
    ExhibitorLine.delete_all
#  ExhibitorRoom.delete_all
    Exhibitor.delete_all
#  Store.delete_all
    Show.delete_all
    Coordinator.delete_all
    Venue.delete_all
    puts "Done clearing the database"
  end

end

