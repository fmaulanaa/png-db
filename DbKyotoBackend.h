/* KyotoCabinet DB backend
 * by Albert Zeyer, 2011
 * code under LGPL
 */

#ifndef __AZ__DBKYOTOBACKEND_H__
#define __AZ__DBKYOTOBACKEND_H__

#include "Db.h"
#include "kyotocabinet/kcpolydb.h"

struct DbKyotoBackend : DbIntf {
	std::string prefix;
	
	DbKyotoBackend(const std::string& prefix = "db.");
	~DbKyotoBackend();
	Return push(/*out*/ DbEntryId& id, const DbEntry& entry);
	Return get(/*out*/ DbEntry& entry, const DbEntryId& id);
	Return pushToDir(const std::string& path, const DbDirEntry& dirEntry);
	Return getDir(/*out*/ std::list<DbDirEntry>& dirList, const std::string& path);
	Return setFileRef(/*can be empty*/ const DbEntryId& id, const std::string& path);
	Return getFileRef(/*out (can be empty)*/ DbEntryId& id, const std::string& path);
};

#endif