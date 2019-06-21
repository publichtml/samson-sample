# frozen_string_literal: true
module SamsonDatadog
  class Engine < Rails::Engine
  end

  class << self
    def send_notification(deploy, **kwargs)
      if deploy.stage.datadog_tags.present?
        DatadogNotification.new(deploy).deliver(**kwargs)
      end
    end
  end
end

Samson::Hooks.view :stage_form, "samson_datadog"
Samson::Hooks.view :stage_show, "samson_datadog"

Samson::Hooks.callback :stage_permitted_params do
  [
    :datadog_tags,
    {datadog_monitor_queries_attributes: [:query, :_destroy, :id]}
  ]
end

Samson::Hooks.callback :before_deploy do |deploy, _|
  SamsonDatadog.send_notification(deploy, additional_tags: ['started'], now: true)
end

Samson::Hooks.callback :after_deploy do |deploy, _|
  SamsonDatadog.send_notification(deploy, additional_tags: ['finished'])
end
