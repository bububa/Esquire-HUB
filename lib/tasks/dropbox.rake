# By Oto Brglez - @otobrglez
# Rake task. Put in your (lib/tasks) folder of your Rails application
# Execute with "rake dropbox:backup"
# Configuration must be inside config/dropbox.yml file

namespace :dropbox do 
  
  desc "Backup production database to dropbox"
  task :backup do
    
    DROPBOX_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/dropbox.yml")[Rails.env]
    
    # Establish API connection to dropbox.
    if not File.exist? 'dropbox_session.txt'
      session = Dropbox::Session.new(DROPBOX_CONFIG["app_key"],DROPBOX_CONFIG["app_secret"])
      session.mode = :dropbox
      
      puts "Visit #{session.authorize_url} to log in to Dropbox. Hit enter when you have done this."
      STDIN.gets
      session.authorize
    
      # Save session information
      File.open('dropbox_session.txt', 'w') do |f|
        f.puts session.serialize
      end
    else
      # Load session information from file
      session = Dropbox::Session.deserialize(File.read('dropbox_session.txt'))
    end
    
    # Your account...
    puts "Using dropbox account #{session.account.display_name}..."
    
    # Create backup of pg database on heroku (also expire old backups)
    puts "Creating pgbackup on Heroku..."
    cmd = "heroku pgbackups:capture -e --app #{DROPBOX_CONFIG["heroku_app_name"]}"
    puts cmd
    out = system(cmd)
    
    backup_name = Time.now.strftime "%y-%m-%d_%H-%M-%S-pg-#{DROPBOX_CONFIG["heroku_app_name"]}.dump"
    
    # Get public URL for latest backup
    public_url = "heroku pgbackups:url --app #{DROPBOX_CONFIG["heroku_app_name"]}"
    cmd = "curl `#{public_url}` --O #{backup_name}"
    puts "#{cmd}"
    out = system(cmd)
    
    # Upload backup to dropbox if getting URL was sucessful.
    if out
      puts "Uploading to dropbox..."
      session.upload backup_name, DROPBOX_CONFIG["backup_path"]
      puts "Done."
    end
  end
  
end