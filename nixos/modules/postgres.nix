{  pkgs,  ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;   # или postgresql_15
    enableTCPIP = true;             # 1С подключается по TCP
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
      # Для подключения с других машин (если сервер 1С на другом хосте)
      # host  all             all             192.168.1.0/24          md5
    '';
    initialScript = pkgs.writeText "init.sql" ''
      CREATE ROLE "1c" WITH LOGIN PASSWORD ' ';
      CREATE DATABASE "1c_doc" OWNER "1c" ENCODING 'UTF8';
    '';
    settings = {
      max_connections = 200;
      shared_buffers = "2GB";        # ~25% от RAM
      effective_cache_size = "6GB";  # ~75% от RAM
      maintenance_work_mem = "256MB";
      work_mem = "16MB";
      standard_conforming_strings = true;
    };
  };
}
