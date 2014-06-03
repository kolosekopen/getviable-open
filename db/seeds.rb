# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

    #TODO: This is working but not from migration
if Stage.all.count == 0
   	Stage.find_or_create_by_title_and_image(:title => "Clarify idea", :image => "clarify")
   	Stage.find_or_create_by_title_and_image(:title => "Identify Customers", :image => "target")
   	Stage.find_or_create_by_title_and_image(:title => "Idea Validation", :image => "discovery")
   	Stage.find_or_create_by_title_and_image(:title => "Design", :image => "design")
   	Stage.find_or_create_by_title_and_image(:title => "Build MVP", :image => "build")
end

if Industry.all.count == 0
  ["Classifieds & Local", "Consumer goods & services", "Education", "Enterprise software", "Finance", 
  	"Games and Gaming", "Healthcare & Wellbeing", "Magazines & News", "Media & Entertainment", 
  	"Productivity", "Professional Services", "Social Networks & Communities", "Shopping / Retail",
  	"Transport", "Travel & Tourism"].each do |title|
    Industry.find_or_create_by_title(:title => title)
  end
end


if Stage.all.count == 5 && SurveySection.all.count > 0
  SurveySection.limit(10).each {|section| section.update_attributes(:stage_id => "1")}
  SurveySection.offset(10).limit(5).each {|section| section.update_attributes(:stage_id => "2")}
  SurveySection.offset(15).limit(7).each {|section| section.update_attributes(:stage_id => "3")}
  SurveySection.offset(22).limit(3).each {|section| section.update_attributes(:stage_id => "4")}
  SurveySection.offset(25).limit(6).each {|section| section.update_attributes(:stage_id => "5")}
  
Question.find(23).update_attributes(:question_reference_id => "22")
Question.find(53).update_attributes(:question_reference_id => "10")
Question.find(66).update_attributes(:question_reference_id => "64")
Question.find(67).update_attributes(:question_reference_id => "11")
Question.find(123).update_attributes(:question_reference_id => "51")
Question.find(155).update_attributes(:question_reference_id => "68")

SurveySection.find(1).update_attributes(:video_url => "ZOCvapc45vE")
SurveySection.find(2).update_attributes(:video_url => "1Ji8jTfi7oA")
SurveySection.find(3).update_attributes(:video_url => "SLPgaA4YTS0")
SurveySection.find(4).update_attributes(:video_url => "")
SurveySection.find(5).update_attributes(:video_url => "-xklvgFAN8g")
SurveySection.find(6).update_attributes(:video_url => "X1A9nroACV8")
SurveySection.find(7).update_attributes(:video_url => "Tt8ja0a3Z-g")
SurveySection.find(8).update_attributes(:video_url => "yUJDZva6-do")
SurveySection.find(9).update_attributes(:video_url => "NGORnhQdwkg")
SurveySection.find(10).update_attributes(:video_url => "1Coj8gohNJg")
SurveySection.find(11).update_attributes(:video_url => "")
SurveySection.find(12).update_attributes(:video_url => "5Aown3Gj0Ak")
SurveySection.find(13).update_attributes(:video_url => "OqmB1C5tZyk")
SurveySection.find(14).update_attributes(:video_url => "mjYewdB-GJI")
SurveySection.find(15).update_attributes(:video_url => "1Coj8gohNJg")
SurveySection.find(16).update_attributes(:video_url => "")
SurveySection.find(17).update_attributes(:video_url => "")
SurveySection.find(18).update_attributes(:video_url => "")
SurveySection.find(19).update_attributes(:video_url => "")
SurveySection.find(20).update_attributes(:video_url => "")
SurveySection.find(21).update_attributes(:video_url => "")
SurveySection.find(22).update_attributes(:video_url => "")
SurveySection.find(23).update_attributes(:video_url => "")
SurveySection.find(24).update_attributes(:video_url => "")
SurveySection.find(25).update_attributes(:video_url => "")
SurveySection.find(26).update_attributes(:video_url => "")
SurveySection.find(27).update_attributes(:video_url => "")
SurveySection.find(28).update_attributes(:video_url => "")
SurveySection.find(29).update_attributes(:video_url => "")
SurveySection.find(30).update_attributes(:video_url => "labRgPR16Hg")
SurveySection.find(31).update_attributes(:video_url => "")


SurveySection.find(1).update_attributes(:description => "What does your idea really mean? What's this idea to you? What is it that you are really trying to solve? Who is it solving this problem for? What is the problem that it is really solving? And how is it solving it?")
SurveySection.find(2).update_attributes(:description => "What is it that you ultimately want to achieve?")
SurveySection.find(3).update_attributes(:description => "This will help you understand what your competitive differentiation will be with your idea.")
SurveySection.find(4).update_attributes(:description => "This will help you understand what your future competitors.")
SurveySection.find(5).update_attributes(:description => "Now its time to start thinking about money - revenue for your service, or your site, or your product.")
SurveySection.find(6).update_attributes(:description => "Does it reflect well on you and your idea? Does it make sense to them? Does this name fit what it is that you are trying to do?")
SurveySection.find(7).update_attributes(:description => "Where to get a great domain name that is available.")
SurveySection.find(8).update_attributes(:description => "Secure your social media presence.")
SurveySection.find(9).update_attributes(:description => "Why is a logo important? How to get a great Logo for your idea.")
SurveySection.find(10).update_attributes(:description => "Handy resources and links for you")
SurveySection.find(11).update_attributes(:description => "Congratulations!")
SurveySection.find(12).update_attributes(:description => "What market are you in? What is your unique value proposition?")
SurveySection.find(13).update_attributes(:description => "Identify your ideal target customer.")
SurveySection.find(14).update_attributes(:description => "What pain point are you addressing in your customers life? Identify up to 3 customer pain areas your product addresses.")
SurveySection.find(15).update_attributes(:description => "Handy resources and links for you")
SurveySection.find(16).update_attributes(:description => "How to test that your customer has a need for your product.")
SurveySection.find(17).update_attributes(:description => "What is your customer's pain point?")
SurveySection.find(18).update_attributes(:description => "How to access your customers.")
SurveySection.find(19).update_attributes(:description => "Why are you better than your competition?")
SurveySection.find(20).update_attributes(:description => "Use a landing page to test your market.")
SurveySection.find(21).update_attributes(:description => "Run an online ad campaign to validate a customer need.")
SurveySection.find(22).update_attributes(:description => "Handy resources and links for you")
SurveySection.find(23).update_attributes(:description => "Start creating your design.")
SurveySection.find(24).update_attributes(:description => "How to get your design excellent.")
SurveySection.find(25).update_attributes(:description => "Define what you want to build.")
SurveySection.find(26).update_attributes(:description => "Check that you're ready to build.")
SurveySection.find(27).update_attributes(:description => "Checklist to define the technology.")
SurveySection.find(28).update_attributes(:description => "Do you need help to build your product?")
SurveySection.find(29).update_attributes(:description => "Tips to get great results with offshore skills.")
SurveySection.find(30).update_attributes(:description => "Recommended skills marketplaces.")
SurveySection.find(31).update_attributes(:description => "Handy resources and links for you")
end

