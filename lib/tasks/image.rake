namespace :images do
  task :create => :environment do
    include ActionDispatch::Routing::UrlFor
    Drawing.all.each do |d|
      param = d.id
      if Rails.env == "development"
        file = CapIt::Capture("#{Rails.configuration.base_url}/drawings/#{param}/1", filename: "#{param}.jpg", min_width: 1000, min_height: 1000)
      elseif Rails.env == "production"
        %x(xvfb --server-args="-screen 0, 1024x768x24" cutycapt --url=#{Rails.configuration.base_url}/drawings/#{param}/1 --out=#{param}.jpg)
      end
      %x(convert #{param}.jpg -resize x200 -crop 200x200+0+0 #{Rails.root.to_path.to_s}/app/assets/images/drawings/#{param}.jpg)
      %x(rm #{file})
      #d.img = true
      #d.save
    end
  end
end
