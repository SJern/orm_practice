class QuestionFollow
  attr_accessor :question_id, :user_id

  def initialize(options)
    @question_id = options ['question_id']
    @user_id = options['user_id']
  end

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.followers_by_question_id(question_id)
    question = Question.find_by_id(question_id)
    raise "#{question_id} not found in DB" unless question

    users = QuestionDBConnection.instance.execute(<<-SQL, question.id)
      SELECT
        users.id
      FROM
        users
        JOIN question_follows ON question_follows.user_id = users.id
      WHERE
        question_id = ?
    SQL

    users.map { |user| User.find_by_id(user['id']) }
  end

  def self.followed_questions_for_user_id(user_id)
    user = User.find_by_id(user_id)
    raise "#{user_id} not found in DB" unless user

    questions = QuestionDBConnection.instance.execute(<<-SQL, user.id)
      SELECT
        questions.id
      FROM
        questions
        JOIN question_follows ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL

    questions.map { |question| Question.find_by_id(question['id']) }
  end

  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id
      FROM
        questions
        JOIN question_follows ON questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.question_id) DESC
      LIMIT
        ?
    SQL
    questions.map { |question| Question.find_by_id(question['id']) }
  end


end
