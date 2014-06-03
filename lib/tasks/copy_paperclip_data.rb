desc "Copy paperclip data"
task :copy_paperclip_data => :environment do
  @users = User.find :all
  @users.each do |user|
    unless user.photo_file_name.blank?
      filename = Rails.root.join('public', 'system', 'photos', user.id.to_s, 'original', user.photo_file_name)
 
      if File.exists? filename
        photo = File.new filename
        user.photo = photo
        user.save
 
        photo.close
      end
    end
  end
end