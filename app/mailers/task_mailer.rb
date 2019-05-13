class TaskMailer < ApplicationMailer
  default from: 'taskleaf@example.com'
  # メールを送るためのメソッド
  # メール本文作成のためにテンプレートで使用するため、インスタンス変数に代入
  def creation_email(task)
    @task = task
    mail(
      subject: 'タスク作成完了メール',
      to: 'user@example.com',
      from: 'taskleaf@example.com'
    )
  end
end
