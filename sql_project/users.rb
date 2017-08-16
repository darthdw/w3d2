require 'byebug'
require_relative('questions_database')

class Users
  attr_reader :id
  attr_accessor :fname, :lname

  # Class Methods
  def self.all
    all_users = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL
    all_users.map {|user| Users.new(user) }
  end

  def self.get_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    Users.new(users.first)
  end

  def self.get_by_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return Users.new(users.first) if users.length > 0
    return nil
  end

  def self.exists?(user)
    users = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    !users.empty?
  end

  # For User Object
  def initialize(options)
    @fname = options["fname"]
    @lname = options["lname"]
    @id = options["id"]
  end

  def create
    raise "User Already Exists!" if Users.exists?(self)
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "User Does Not Exist!" unless Users.exists?(self)
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end

  def delete
    raise "User Does Not Exist!" unless Users.exists?(self)
    QuestionsDatabase.instance.execute(<<-SQL, @id)
      DELETE FROM
        users
      WHERE
        id = ?
    SQL
  end
end

# find_by_id
