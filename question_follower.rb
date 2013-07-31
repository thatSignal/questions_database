class QuestionFollower
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      question_followers.id = ?
    SQL

    QuestionFollower.new(result.first)
  end

  def self.followers_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      question_followers
    INNER JOIN
      users ON users.id = question_followers.follower_id
    WHERE
      question_followers.question_id = ?
    SQL

    result.map { |follower| User.new(follower) }
  end

  def self.followed_questions_for_user_id(user_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_followers
    INNER JOIN
      questions ON questions.id = question_followers.question_id
    WHERE
      question_followers.follower_id = ?
    SQL

    result.map { |question| Question.new(question) }
  end

  def self.most_followed_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questions
    LEFT JOIN
      question_followers ON questions.id = question_followers.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(question_followers.follower_id) DESC
    LIMIT ?
    SQL

    result.map { |question| Question.new(question) }
  end

  attr_reader :id, :question_id, :follower_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end
end
