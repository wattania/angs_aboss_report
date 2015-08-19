require 'etc'
require 'fileutils'
require 'pg'

PG_VERSION = '9.4'
PG_DATA_PATH = "/pgdata"
PG_USER = "postgres"
PG_BIN = "/usr/pgsql-#{PG_VERSION}/bin"
SUPER_USER_PASSWD = "Angstroms99!"
USERS = [ 'angs_aboss_report' ]

def set_dir_owner path, user
  user_uid = nil
  Etc.passwd {|u| user_uid = u.uid if u.name == user }
  if user_uid.nil?
    raise "User #{user} not exist!"
  else
    unless File.stat(path).uid == user_uid
      FileUtils.chown_R user, user, path
    end
  end
  true
end

def run_pg_user cmd
  "su - #{PG_USER} -c '#{cmd}'"
end

def pg_ctl params = []
  txt = nil
  if params.is_a? Array
    txt = " #{params.join ' '}"
  elsif params.is_a? String
    txt = " #{params}"
  end
    
  run_pg_user "#{PG_BIN}/pg_ctl -D #{PG_DATA_PATH}#{txt}"
end

def create_passwd_file a_path 
  ret = true
  File.open a_path, "wb" do |f| f.write SUPER_USER_PASSWD end

  (ret = yield if block_given?) rescue ret = false

  File.delete a_path
  ret
end

def initdb passwd_file_path
  run_pg_user "#{PG_BIN}/initdb --encoding=UTF-8 -D #{PG_DATA_PATH} --pwfile=#{passwd_file_path} --auth=md5"
end

def create_user user
  "#{PG_BIN}/createuser --host=127.0.0.1 --port=5432 --username=postgres --encrypted --no-password #{user}"
end

def create_db db_name, owner
  "#{PG_BIN}/createdb --host=127.0.0.1 --port=5432 --username=postgres --encoding=UTF-8 --owner=#{owner} --no-password #{db_name}"
end

def run_cmd desc, cmd = nil
  ret = true
  puts 
  puts "-------------------------------------------------------------"
  puts ":: #{desc} >>> #{cmd}"
  if block_given?
    ret = yield
    if ret
      ret = true 
    else
      ret = false
    end
  else
    ret = system cmd
  end
  puts "   -> #{ret}"
  ret
end

def main
  run_cmd "Create .pgpass", "echo '127.0.0.1:5432:*:postgres:#{SUPER_USER_PASSWD}' > ~/.pgpass && chmod 600 ~/.pgpass"
  run_cmd "Set PGDATA" do set_dir_owner PG_DATA_PATH, PG_USER end

  unless (Dir.entries(PG_DATA_PATH) - %w{ . .. }).empty?
    return unless run_cmd "Clear PGDATA contents", "rm -rf #{PG_DATA_PATH}/*"
  end
 
  return unless create_passwd_file "/pgpass" do
    run_cmd "Init Database", (initdb "/pgpass")
  end

  run_cmd "Insert Authen host" do 
    File.open("/pgdata/pg_hba.conf", 'a') do |f| f << "host all all 0.0.0.0/0 md5\n" end
    true
  end

  run_cmd "Insert listen address (*)" do
    File.open("/pgdata/postgresql.conf", 'a') do |f| f << "listen_addresses = '*'\n" end
    true
  end

  run_cmd "Start PG Server", (pg_ctl "start")

  puts "----------------------------------------------"
  puts ": Sleep 2 seconds"
  sleep 2

  run_cmd "Create Role",  (create_user  'angs_aboss_report')
  run_cmd "Create DB",    (create_db    'angs_aboss_report_prod', 'angs_aboss_report')
  run_cmd "Create DB",    (create_db    'angs_aboss_report_dev',  'angs_aboss_report')
  run_cmd "Create DB",    (create_db    'angs_aboss_report_test', 'angs_aboss_report')

  run_cmd "Stop PG Server", (pg_ctl "stop")

end

if __FILE__ == $0
  main 
  puts ": Bye!"
end