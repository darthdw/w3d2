require_relative('questions_database')

class Questions
  attr_reader :id, :user_id
  attr_accessor :title, :body

  # Class Methods
  def self.all
    all_questions = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
    SQL
    all_questions.map {|question| Questions.new(question) }
  end

  def self.get_by_user_id(user_id)
    questions= QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
       user_id = ?
    SQL
    questions.map { |questions| Questions.new(questions)}
  end

  def self.get_by_title(title)
    questions = QuestionsDatabase.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
       title = ?
    SQL
    Questions.new(questions.first)
  end

  def self.get_by_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Questions.new(questions.first)
  end

  def self.user_exists?(user_id)
    user = Users.get_by_id(user_id)
    user.nil?
  end

  def self.exists?(question)
    return false if question.id.nil?

    questions = QuestionsDatabase.instance.execute(<<-SQL, question.id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    !questions.empty?
  end

  # For question Object
  def initialize(options)
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
    @id = options["id"]
  end

  def create
    raise "Question Already Exists!" if Questions.exists?(self)
    raise "User ID Does Not Exist >:|" if Questions.user_exists?(@user_id)
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO
        questions (title, body, user_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "Question Does Not Exist!" unless Questions.exists?(self)
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?
      WHERE
        id = ?
    SQL
  end

  def delete
    raise "question Does Not Exist!" unless Questions.exists?(self)
    QuestionsDatabase.instance.execute(<<-SQL, @id)
      DELETE FROM
        questions
      WHERE
        id = ?
    SQL
  end
end

# find_by_id
