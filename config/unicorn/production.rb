root = "/home/ubuntu/apps/circlez_and_squarez/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.circlez_and_squarez.sock"
worker_processes 2
timeout 30
