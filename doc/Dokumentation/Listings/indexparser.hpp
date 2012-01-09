/** Class Index
 *
 *  This class creates an index of different input files.
 *
 *  author  Alexander Miller
 *  date    11.5.2011
 *  version 0.1
 */

#ifndef _INDEXPARSER_H
#define _INDEXPARSER_H

#include <string>
#include <iostream>
#include <set>

#include "index.hpp"
#include "stringutil.hpp"


using namespace std;

class IndexParser {
private:	

	Index *index; // this is our reference to the index instance
	
	/**
	 * Read IndexFile and store each line into vector<string>
	 * @param *lines container to store all text lines
	 * @param index_file IndexFile for parsing
	 */
	void fileToLines(vector<string> *lines, string index_file);

	/**
	 * Parse given lines
	 * @param *lines Lines for parsing
	 */
	void parseAllLines(vector<string> *lines);

	/**
	 * Parse current line
	 * @param linie Current line for parsing
	 * @param flag_wort Variable give information about parsing progress --> true = Word determined 
	 * @param flag_file Variable give information about parsing progress --> true = File determined 
	 * @param flag_index Variable give information about parsing progress --> true = Index determined 
	 */
	string parseLine(string linie, bool flag_wort, bool flag_file, bool flag_index, string last_word);

public:
	/**
	 * Create an object.
	 * @param *index IndexFile for parsing 
	 */
	IndexParser(Index *index);
	
	/**
	 * Destroy the object.
	 */
	~IndexParser();	

	/**
	 * Read each line from given index file.
	 * Parse word, file and index from each line. 
	 * Insert parsed data in index map.
	 * @param index_file  index file to be read.
	 */
	void readIndexFile(string index_file);  
};

#endif	/* _INDEXPARSER_H */
