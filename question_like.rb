class QuestionLike
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.id = ?
    SQL

    QuestionLike.new(result.first)
  end

  def self.likers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      question_likes
    INNER JOIN
      users ON users.id = question_likes.liker_id
    WHERE
      question_likes.question_id = ?
    SQL

    result.map { |liker| User.new(liker) }
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(question_likes.liker_id)
    FROM
      question_likes
    WHERE
      question_likes.question_id = ?
    SQL

    result.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    result = QuestionDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_likes
    INNER JOIN
      questions ON questions.id = question_likes.question_id
    WHERE
      question_likes.liker_id = ?
    SQL

    result.map { |liked_q| Question.new(liked_q)}
  end


  def self.most_liked_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questions
    LEFT JOIN
      question_likes ON question_likes.question_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(question_likes.liker_id) DESC
    LIMIT
      ?
    SQL

    result.map{ |question| Question.new(question) }
  end

  attr_reader :id, :question_id, :liker_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @liker_id = options['liker_id']
  end
end