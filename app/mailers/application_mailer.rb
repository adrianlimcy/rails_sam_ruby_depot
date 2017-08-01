class ApplicationMailer < ActionMailer::Base
  default from: 'helpdesk@ricohmds.onmicrosoft.com'
  layout 'mailer'
  add_template_helper ApplicationHelper
end
