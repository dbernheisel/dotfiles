# https://github.com/carlhuda/bundler/issues/183#issuecomment-1149953
if defined?(::Bundler)
  if ENV['GEM_PATH']
    global_gemset = ENV['GEM_PATH'].split(':').grep(/ruby.*@global/).first
    if global_gemset
      all_global_gem_paths = Dir.glob("#{global_gemset}/gems/*")
      all_global_gem_paths.each do |p|
        gem_path = "#{p}/lib"
        $LOAD_PATH << gem_path
      end
    end
  end
end
if defined?(::Pry)
  Pry.start
  exit
end
