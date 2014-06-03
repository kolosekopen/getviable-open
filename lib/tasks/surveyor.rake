namespace :surveyor do

  desc 'GetViable Questions'
  task :questions => :environment do
    ENV['GET_QUESTIONS'] = 'true'
    ENV['FILE'] = 'surveys/get_viable_questions_leslie_v3-2-2.rb'

    Rake::Task['surveyor'].reenable
    Rake::Task['surveyor'].invoke
  end

  desc "generate a surveyor DSL file from a survey"
  task :custom_unparse => :environment do
    surveys = Survey.all
    if surveys
      puts "The following surveys are available"
      surveys.each do |survey|
        puts "#{survey.id} #{survey.title}"
      end
      print "Which survey would you like to unparse? "
      id = $stdin.gets.to_i
      if survey_to_unparse = surveys.detect{|s| s.id == id}
        filename = "surveys/#{survey_to_unparse.access_code}_#{Date.today.to_s(:db)}.rb"
        puts "unparsing #{survey_to_unparse.title} to #{filename}"
        File.open(filename, 'w') {|f| f.write(survey_to_unparse.custom_unparse(dsl = ""))}
      else
        puts "not found"
      end
    else
      puts "There are no surveys available"
    end
  end

end
