DOCKER_USER  = "angstroms"
PROJECT_NAME ="angs_aboss_report"

def docker_path
 "docker.io/#{DOCKER_USER}/#{PROJECT_NAME}" 
end

def tag
 "#{docker_path}:latest"
end

def main param
  current_dir = Dir.pwd

  cmds = [
    "cd #{File.join current_dir, 'docker', 'appserver'}",
    "sh build_docker.sh",
    "cd #{File.join current_dir, 'docker', 'postgresql'}",
    "sh build_docker.sh"
  ]

  system cmds.join ' && '
  puts "-------------"
 
  cmd = "docker build -t #{tag} -f #{current_dir}/Dockerfile #{current_dir}"
  puts cmd
  puts " --> #{system cmd}"
  puts " -------------- "
  #system "docker push #{tag}"
  case param
  when 'copy_gemfile_lock'
    cmd = [
      "docker run --rm",
      "-v #{current_dir}:/backup"
      "--privileged"
      docker_path,
      "copy -f /tmp/Gemfile.lock /backup/appserver/"
    ].join ' '
    puts cmd
    puts " --> #{system cmd}"
  end
end

if __FILE__ == $0
  main ARGV[0]
end
