require 'jammit'
namespace :assets do
  task :package do
    Jammit.package!
  end
end