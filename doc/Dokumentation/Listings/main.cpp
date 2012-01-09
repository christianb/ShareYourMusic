#include <iostream>
#include <string>

#include "controller.hpp"

using namespace std;

/**
* @mainpage Index - Project for Parametric Programming
* @section Programmaufruf
* Creates an index from input files into one output file.
* @code
* index -i <outputFile> <inputFile>+
* @endcode
* Print the index from given index file.
* @code
* index -p <indexFile>
* @endcode
* Print the index only for this word
* @code
* index -q=<word> indexFile
* @endcode
* Print index where the given word is at the beginning.
* @code
* index -s=<word> indexFile
* @endcode
* Print the index the given word is anywhere in another word.
* @code
* index -s=<*word> indexFile
* @endcode
* Print the index for words occuring in that file.
* @code
* index -t=<file> indexFile
* @endcode
*
* @section Copyright
* @authors Alexander Miller, Christian Bunk
*/
int main (int argc, char *argv[]) {
	Controller *ctr = new Controller(argc, argv);
	delete ctr;
	
	return EXIT_SUCCESS;
}
