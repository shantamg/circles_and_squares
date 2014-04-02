namespace :images do
  task :create => :environment do
    include ActionDispatch::Routing::UrlFor
    Drawing.where(img: false).each do |d|
      param = d.id
      if (file = CapIt::Capture("#{Rails.configuration.base_url}/drawings/#{param}/1", filename: "#{param}.jpg", min_width: 1000, min_height: 1000))
        %x(convert #{file} -resize x200 -crop 200x200+0+0 #{Rails.root.to_path.to_s}/app/assets/images/drawings/#{param}.jpg)
        %x(rm #{file})
        d.img = true
        d.save
      end
    end
  end
end
