DOCKER_USER  = "angstroms"
PROJECT_NAME ="angs_aboss_report"

def get_tag a_path
  
end

def main
  current_dir = Dir.pwd

  cmds = [
    "cd #{File.join current_dir, 'docker', 'appserver'}",
    "sh build_docker.sh",
    "cd #{File.join current_dir, 'docker', 'postgresql'}",
    "sh build_docker.sh"
  ]

  system cmds.join ' && '
  puts "-------------"
 
  cmd = "docker build -t docker.io/#{DOCKER_USER}/#{PROJECT_NAME} -f #{current_dir}/Dockerfile #{current_dir}"
  puts cmd
  puts " --> #{system cmd}"
end

main if __FILE__ == $0
