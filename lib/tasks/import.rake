# frozen_string_literal: true

namespace :membership do
  task link_to_camdram: :environment do
    File.open('members-merged.csv', 'w') do |file|
      File.readlines('members.csv').each do |line|
        parts = line.chomp.split(',')
        name = "#{parts[2]} #{parts[1]}"
        puts "Searching Camdram for #{name} who graduated in #{parts[6]}..."
        entities = ::Membership::Camdram.client.search(name).select do |entity|
          entity.entity_type == 'person'
        end
        puts 'Found the following people:'
        entities.each do |entity|
          puts "#{entity.name} (id #{entity.id}) who was last active on #{entity.last_active}"
        end
        print 'Enter Camdram ID or leave blank to accept first: '
        parts[0] = STDIN.gets.chomp
        parts[0] = entities.first.id if parts[0].blank? && entities.length > 0
        file.puts parts.join(',')
        puts parts.inspect
        puts ''
      end
    end
  end
end
