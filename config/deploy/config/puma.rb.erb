#!/usr/bin/env puma

directory "<%= current_path %>"
rackup DefaultRackup
environment "<%= fetch(:rails_env) %>"

pidfile "<%= shared_path %>/tmp/pids/puma.pid"
state_path "<%= shared_path %>/tmp/pids/puma.state"
activate_control_app
stdout_redirect '<%= shared_path %>/log/puma_access.log', '<%= shared_path %>/log/puma_error.log', true

threads 1, 3

bind 'unix://<%= shared_path %>/tmp/sockets/<%= fetch(:application) %>-puma.sock'

workers 1

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
