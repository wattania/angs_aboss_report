
def main
  current_dir = Dir.pwd

  cmds = [
    "cd #{File.join current_dir, 'docker', 'appserver'}",
    "sh build_docker.sh",
    "cd #{File.join current_dir, 'docker', 'postgresql'}",
    "sh build_docker.sh"
  ]

  system cmds.join ' && '
end

main if __FILE__ == $0

=begin
cd docker/appserver \
&& sh build_docker.sh \
&& cd ../.. \
&& docker build -t docker.io/angstroms/angs_aboss_report .
=end