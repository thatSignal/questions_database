class Model
  def save(attrs)
    if @id
      update_str = "UPDATE #{@TABLE_NAME} SET #{@UPDATE_STRING} WHERE id = ?"
      p update_str
      QuestionsDatabase.instance.execute(update_str, *attrs)
    else
      attrs.pop
      insert_str = "INSERT INTO #{@TABLE_NAME} #{@INSERT_STRING}"
      QuestionsDatabase.instance.execute(insert_str, *attrs)
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
end



class User < Model


  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL
    User.new(result.first)
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      users.fname = ? AND users.lname = ?
    SQL

    User.new(result.first)
  end

  attr_reader :id
  attr_accessor :fname, :lname

  def initialize(options = {})
    @INSERT_STRING = "(fname, lname) VALUES (?, ?)"
    @UPDATE_STRING = "fname = ?, lname = ?"
    @TABLE_NAME = "users"

    @id = options['id'] # Hash#values_at("id", "fname", "lname")
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      AVG(count) AS average_karma
    FROM
      (SELECT
        COUNT(question_likes.liker_id) AS count
      FROM
        question_likes
      INNER JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
      GROUP BY
        questions.id)
    SQL

    result.first["average_karma"]
  end

  def save
    attrs = [@fname, @lname, @id]
    super(attrs)
  end

end