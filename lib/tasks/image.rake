namespace :images do
  task :create => :environment do
    include ActionDispatch::Routing::UrlFor
    Drawing.where(img: false).each do |d|
      file = CapIt::Capture("#{Rails.configuration.base_url}/drawings/#{d.to_param}/1", min_width: 900, min_height: 900)
      %x(convert #{file} -resize 200x200 #{Rails.root.to_path.to_s}/public/drawings/#{d.to_param}.jpg)
      d.img = true
      d.save
    end
  end
end
