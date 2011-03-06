/* simple DB interface
 * by Albert Zeyer, 2011
 * code under LGPL
 */

#ifndef __AZ__DB_H__
#define __AZ__DB_H__

#include "Return.h"
#include <string>

struct DbEntry {
	std::string data;
	std::string sha1;
	
	DbEntry() {}
	DbEntry(const std::string& d) : data(d) { calcSha1(); }
	bool haveSha1() const { return !sha1.empty(); }
	void calcSha1();
};

typedef std::string DbEntryId; /* guaranteed to not contain \0 and to be not empty */

std::string filenameForDbEntryId(const DbEntryId& id);
std::string dirnameForSha1Ref(const std::string& sha1); // asserts that sha1.size() == SHA1_DIGEST_SIZE
std::string filenameForSha1Ref(const std::string& sha1, const DbEntryId& id);

struct Db {
	std::string baseDir;
	
	Return push(/*out*/ DbEntryId& id, const DbEntry& entry);
	Return get(/*out*/ DbEntry& entry, const DbEntryId& id);
};

#endif