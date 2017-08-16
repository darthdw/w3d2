require_relative "questions_database"

# id INTEGER PRIMARY KEY,
# question_id INTEGER NOT NULL,
# user_id INTEGER NOT NULL,
# body TEXT,
# parent INTEGER


class Replies

 #CLASS Methods
 attr_accessor  :body

  def self.all
    replies = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    replies.map{|reply| Replies.new(reply)}
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
   SQL
   replies.map{|reply| Replies.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
   SQL
   Replies.new(replies.first)
 end

  def self.question_exists?(question_id)
    q = Questions.get_by_id(question_id)
    q.nil?
  end


  #instance Methods
  def initialize(options)
    @id          = options["id"]
    @question_id = options["question_id"]
    @user_id     = options["user_id"]
    @body        = options["body"]
    @parent      = options["parent"]
  end


  def author
    author = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    Users.new(author.first)
  end

  def question
    question = QuestionsDatabase.instance.execute(<<-SQL,@question_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.id = ?
     SQL
     Questions.new(question.first)
  end

  def parent_reply
  end

  def child_reply
  end

  def create
    raise "Question doesn't exist!" if Replies.question_exists?(@question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL,@question_id, @user_id, @body, @parent)
      INSERT INTO
        replies(question_id, user_id, body, parent)
      VALUES
        (?,?,?,?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    reply = QuestionsDatabase.instance.execute(<<-SQL,@body,@id)
      UPDATE
        replies
      SET
        body = ?
      WHERE
        id = ?
    SQL
  end

  def delete
    reply = QuestionsDatabase.instance.execute(<<-SQL,@id)
    DELETE FROM
      replies
    WHERE
      id=?
    SQL
  end



end
