#ifndef _STRINGUTIL_H
#define _STRINGUTIL_H

#include <string>
//#include <iostream>
#include <sstream>
#include <algorithm>

using namespace std;

/** Class StringUtil
 *
 *  This class provides some usefull string methods.
 *
 *  author  Christian Bunk
 *  date    15.5.2011
 *  version 0.1
 */
class StringUtil {
public:
	
	/**
	 * Convert a single value into a string.
	 * @param value The value to be convert into a string. Must implement operator<<() !
	 * @return string The string representation of the value.
	 */
	template <typename Type>
	string toString(Type value) {
		ostringstream strout;
		strout << value;
		
		return (strout.str());
	}
	
	/**
	 * Convert a string into a given data type
	 * @param str The string to be converted into a special data type.
	 * @param &value The variable where the representation of the string definded by the data type is stored. call-by-reference! Must implement operator>>() !
	 */
	template <typename Type>
	void stringTo(string str, Type &value) {
	    istringstream strin;

	    strin.str(str);
	    strin >> value;
	}
	
	/**
	 * Transfomrs a given string to lower case letters.
	 * @param &str The string to be transformed given as an reference. call-by-reference!
	 */
	void toLowerCase(string &str);
	
};

#endif	/* _STRINGUTIL_H */
