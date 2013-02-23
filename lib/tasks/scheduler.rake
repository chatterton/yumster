desc "Keep alive"
task :keep_alive => :environment do
  uri = URI.parse('http://localhost:3000/pages/asdf')
  Net::HTTP.get(uri)
end
