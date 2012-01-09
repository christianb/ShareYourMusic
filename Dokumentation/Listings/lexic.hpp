#include <string>
#include <iostream>

using namespace std;

/** Class Lexic
 *
 *  This class is responsilbe for the lexicografical ordering in the index.
 *
 *  author  Christian Bunk
 *  date    19.5.2011
 *  version 0.1
 */
class Lexic {
public: 
	/**
	 * This operator() is called by the map, when a new element is inserted to bring it in the right order.
	 * The sort order is lexicografic.
	 * @return bool
	 * @param s1 The first string compare to the second.
	 * @param s2 The second string compare to the first.
	 */
	bool operator()(string s1, string s2);
	
private:
	/** 
	 * A case-insensitive comparison function.
	 * @param c1
	 * @param c2
	 * @return bool
	 */
	static bool mycomp (char c1, char c2);
	
	bool isWordEqualCaseInsensitiv(string s1, string s2);
} ;