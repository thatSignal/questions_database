class Question < Model
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.id = ?
    SQL

    Question.new(result.first)
  end

  def self.find_by_author_id(author_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.author_id = ?
    SQL

    result.map{ |question| Question.new(question) }
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_reader :id, :title, :body, :author_id

  def initialize(options = {})
    @INSERT_STRING = "(title, body, author_id) VALUES (?, ?, ?)"
    @UPDATE_STRING = "title = ?, body = ?, author_id = ?"
    @TABLE_NAME = "questions"

    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def save
    attrs = [@title, @body, @author_id, @id]
    super(attrs)
  end
end