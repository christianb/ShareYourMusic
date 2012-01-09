#ifndef _FILETUIL_H
#define _FILEUTIL_H

#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <iterator>

using namespace std;

/** Class FileUtil
 *
 *  This class provides methods to read and write content to a file.
 *
 *  author  Christian Bunk
 *  date    15.5.2011
 *  version 0.1
 */
class FileUtil {
public:	
	/**
	 * Read content from a given File.
	 * Returns a map with the filename as the key and the content of the file as the value.
	 * @param files Contains all files to read in.
	 * @return map<string, vector<string>*> A map, containing all lines as the value for the file as the key.
	 */	
	map<string, vector<string>* > readFiles(vector<string> files);
	
	/**
	 * Write content to file.
	 * @param out_file The file where the content will be written.
	 * @param content The content to be written into file.
	 */
	void writeFile(string out_file, string content);

private:
	/**
	 * Read all lines within a file.
	 * @param file The file to read from.
	 * @return vector<string>* All lines within the file.
	 */
	vector<string>* readAllLinesFromFile(string file);
};

#endif	/* _FILEUTIL_H */
