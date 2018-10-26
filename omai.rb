require "#{Dir.pwd}/lib/omai5/helper_functions.rb"
require "#{Dir.pwd}/lib/omai5/skill.rb"
character = Nokogiri::XML(File.read('/Volumes/Data Swap/Tabletop RPGs/Character Sheets/Runnerhub/Babsí/Babsí.chum5'))
# Reading Skills
boop = Omai5::Skill.from_base_node(character)
boop.each do |skill|
  puts skill unless skill.defaulting?
end
Omai5::SkillGroup.skill_group_list(version: boop[0].version).each do |skill_group|
  print "#{skill_group}: "
  if Omai5::SkillGroup.broken?(skill_group, boop)
    puts 'Broken'
  else
    puts 'Intact'
  end
end
puts 'Done Chummer!'
