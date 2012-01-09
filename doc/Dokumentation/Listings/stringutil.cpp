#include "stringutil.hpp"

void StringUtil::toLowerCase(string &str) {
	transform(str.begin(), str.end(), str.begin(), ::tolower);
}
