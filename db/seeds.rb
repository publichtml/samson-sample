# frozen_string_literal: true

if Environment.all.empty?
  Environment.create!(name: 'Master')

  project = Project.create!(
    name: "rails7-samson-sample-client",
    repository_url: "https://github.com/publichtml/rails7-samson-sample-client.git"
  )

  stage = project.stages.create!(
    name: "Production"
  )

  command = Command.create!(
    command: <<~EOS
      export TARGET_HOST=app
      export TARGET_HOST_PORT=22

      bundle install
      bundle exec cap production deploy
    EOS
  )

  StageCommand.create!(
    stage_id: stage.id,
    command_id: command.id,
    position: 0
  )
end

