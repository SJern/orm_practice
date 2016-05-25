class QuestionLike
  attr_accessor :user_id, :question_id

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.liked_questions_for_user_id(user_id)
    user = User.find_by_id(user_id)
    raise "#{user_id} not in db" unless user
    questions = QuestionDBConnection.instance.execute(<<-SQL, user.id)
      SELECT
        questions.id
      FROM
        questions
        JOIN question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL

    questions.map { |question| Question.find_by_id(question['id'])  }
  end

  def self.likers_for_question_id(question_id)
    question = Question.find_by_id(question_id)
    raise "#{question_id} not in db" unless question

    likers = QuestionDBConnection.instance.execute(<<-SQL, question.id)
      SELECT
        users.id
      FROM
        users
        JOIN question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    likers.map { |liker| User.find_by_id(liker['id']) }
  end

  def self.num_likes_for_question_id(question_id)
    question = Question.find_by_id(question_id)
    raise "#{question_id} not in db" unless question

    num_likers = QuestionDBConnection.instance.execute(<<-SQL, question.id)
      SELECT
        COUNT(users.id) AS num_likers
      FROM
        users
        JOIN question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL

    num_likers.first['num_likers']
  end

  def self.most_liked_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id
      FROM
        questions
        JOIN question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        ?
    SQL

    questions.map { |question| Question.find_by_id(question['id']) }
  end

end
