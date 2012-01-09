#include "lexic.hpp"

using namespace std;

#ifdef Lexic_Compare_Standard
// Vergleichsfunktion ohne Beruecksichtigung von Gross- und Kleinschreibung :
bool compare (char c1, char c2)
{ 
	return tolower(c1) < tolower(c2) ;
}

bool Lexic::operator()(string s1, string s2)
{
	return lexicographical_compare(s1.begin(), s1.end(), s2.begin(), s2.end(), compare) ;
}
#else

bool Lexic::operator()(string s1, string s2) {
	string::iterator s1_it = s1.begin();
	string::iterator s2_it = s2.begin();
	
	// check strings of case insensitive equality
	while (s1_it != s1.end() || s2_it != s2.end()){
		// s1 is lower than s2
		if (tolower(*s1_it) < tolower(*s2_it)) {
			return true;
		}
		
		// s1 is greater than s2
		if (tolower(*s1_it) > tolower(*s2_it)) {
			return false;
		}	
		
		s1_it++;
		s2_it++;
	}; 
	
	// here either both strings are euqal or one is longer and contains the other string
	
	// if both are equal make a check for CASE SENSITIVE difference
	if (s1.size() == s2.size()) {
		s1_it = s1.begin();
		s2_it = s2.begin();
		
		while(s1_it != s1.end() && s2_it != s2.end()) {
			// s1 is lower than s2 (CASE SENSITIVE)
			if (*s1_it < *s2_it) {
				return true;
			}
			
			// s1 is greater than s2 (CASE SENSITVE)
			if (*s1_it > *s2_it) {
				return false;
			}

			s1_it++;
			s2_it++;
		};
		
		// if it comes here both strings are even CASE SENSITIVE exactly the same
		return false;
	} else {
		return (s1.size() < s2.size()); // true if s1 is lower than s2, false otherwise
	}
}
#endif
