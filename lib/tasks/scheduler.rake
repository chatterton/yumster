desc "Keep alive"
task :keep_alive => :environment do
  uri = URI.parse('http://www.yumster.co/pages/asdf')
  Net::HTTP.get(uri)
end
