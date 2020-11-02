# frozen_string_literal: true

rails_environment = ENV.fetch('RAILS_ENV') { 'development' }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
workers_count = ENV.fetch('WEB_CONCURRENCY') { 2 }

environment rails_environment
threads threads_count, threads_count
workers workers_count

if rails_environment == 'production'
  bind 'unix:///var/run/membership/puma.sock'
  worker_timeout 15
  worker_boot_timeout 15
  worker_shutdown_timeout 15
else
  port ENV.fetch("PORT") { 3000 }
end

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
