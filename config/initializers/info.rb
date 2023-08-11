require Rails.root.join("lib", "membership", "info_nugget.rb")
include ActionView::Helpers::DateHelper

::Membership::BOOTED_AT = Time.now

::Membership::InfoNugget.new_at_head "System hostname", -> { `hostname -f` }
::Membership::InfoNugget.new_at_head "System date", -> { Time.now.strftime("%d/%m/%Y") }
::Membership::InfoNugget.new_at_head "System time", -> { Time.now.strftime("%k:%M:%S") }
::Membership::InfoNugget.new_at_head "System uptime", -> { time_ago_in_words(Time.now - IO.read('/proc/uptime').split[0].to_f, include_seconds: true) }
::Membership::InfoNugget.new_at_head "Application uptime", -> { time_ago_in_words(::Membership::BOOTED_AT, include_seconds: true) }
::Membership::InfoNugget.new_at_head "Application version", -> { ::Membership::Version.git_desc }
::Membership::InfoNugget.new_at_head "Software revision", -> { ::Membership::Version.git_date }
::Membership::InfoNugget.new "Bundler version", 10, -> { ENV['BUNDLER_VERSION'] }
::Membership::InfoNugget.new_at_end "Rails Max Threads", -> { ENV['RAILS_MAX_THREADS'] }
::Membership::InfoNugget.new_at_end "Rails Web Concurrency", -> { ENV['WEB_CONCURRENCY'] }
::Membership::InfoNugget.new_at_end "Working directory", -> { Dir.pwd }
::Membership::InfoNugget.new_at_end "Temporary directory", -> { Dir.tmpdir }

::Membership::InfoNugget.new_at_end "Member count", -> { Member.count }
::Membership::InfoNugget.new_at_end "Institution count", -> { Institution.count }
::Membership::InfoNugget.new_at_end "Show contact detail count", -> { ShowContactDetails.count }
::Membership::InfoNugget.new_at_end "Sent mail count", -> { SentMail.count }

GC.stat.each do |key, _|
  ::Membership::InfoNugget.new_at_end "GC #{key}", -> { GC.stat[key] }
end
