require 'ffaker'

desc 'generate fake member data'
task :generate_fake_members, [:number_of_members, :number_of_groups] => :environment do |_, args|
  number_of_members = (args[:number_of_members] || 20).to_i
  number_of_groups = (args[:number_of_groups] || number_of_members * rand(1..3))

  number_of_groups.times do
    group = Group.create!(name: FFaker::Company.name)
    puts "Created group #{group.name}"
  end

  number_of_members.times do
    member = Member.new(name: FFaker::Name.name, email: FFaker::Internet.email)
    group = Group.offset(rand(Group.count)).first
    member.groups << group
    member.save!
    puts "Created member #{member.name} in group #{group.name}"
  end
end

desc 'generate fake member data with teams of one'
task :generate_fake_teams_of_one, [:number_of_members] => :environment do |_, args|
  (args[:number_of_members] || 20).to_i.times do
    group = Group.create!(name: FFaker::Company.name)
    member = Member.new(name: FFaker::Name.name, email: FFaker::Internet.email)
    member.groups << group
    member.save!
    puts "Created member and group #{member.name}"
  end
end
