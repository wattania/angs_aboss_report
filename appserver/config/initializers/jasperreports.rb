#require 'xls'
if defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
  ["lib", "dist"].each{|folder|
    java_libs_path = Rails.root.join "jasperreports", folder
    
    Dir.entries(java_libs_path).select {|entry|
      require File.join(java_libs_path, entry).to_s if entry.end_with? ".jar"
    }  
  }
end