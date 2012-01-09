#ifndef _INDEX_H
#define _INDEX_H

#include <fstream>
#include <iostream>
#include <iterator>
#include <vector>
#include <string>
#include <map>
#include <set>
#include <sstream>
#include <algorithm>

#include "stringutil.hpp"
#include "fileutil.hpp"
#include "lexic.hpp"

using namespace std;

/**
 * word is a string
 */
typedef string word; 

/**
 * file is a string
 */					
typedef string file;					

/**
 * line_number is an int
 */
typedef int line_number;

/**
 * line_numbers is a set containing int's
 */
typedef set<line_number, less<int> > line_numbers; 

/**
 * files is a map containing the file(name) and a set of line number's
 */
typedef map<file, line_numbers* > files;

/**
 * words is a map containing the word an another map (with files and line number's)
 */
#ifdef Lexic_Compare
	typedef map<word, files*, Lexic > words;
#else
	typedef map<word, files*> words;
#endif

/** Class Index
 *
 *  This class creates an index of several input files.
 *
 *  author  Christian Bunk
 *  date    3.5.2011
 *  version 0.1
 */
class Index {
private:	
	// this map stores for each word, another map
	words *_word_index; // stores a pointer to map_files
	
	StringUtil *s_util; // reference to StringUtil
	
	FileUtil *f_util; // reference to FileUtil
	
	/**
	 * Doing some initial stuff.
	 */
	void init();
	
	// Read and write files:
	
	/**
	 * Read content (from given files).
	 * @param files
	 */	
	void readContent(vector<file> files);
	
	/**
	 * Write content (into file).
	 * @param out_file
	 */
	void writeContent(file out_file);
	
	
	// Build the index:

	/**
	 * Read all lines within a file.
	 * @return vector<string>* All lines within the file.
	 */
	vector<string>* readAllLines(file f);
	
	/**
	 * Exctract all words from a line.
	 * Rules: each empty character will be ignored
	 */
	vector<word> extractAllWordsFromLine(string line);
	
	/**
	 * Add a word into the index, corresponding to a file and a line number.
	 * This mehtod is used by addToIndex(vector<word>, file, line_number)
	 * @param w
	 * @param f
	 * @param l
	 */
	void addToIndex(word w, file f, line_number l);
	
	/**
	 * Add a vector of words into the index, corresponding to a file and a line number.
	 * Use the method addToIndex(word, file, line_number)
	 * This method is used when the index is created.
	 * @param words
	 * @param f
	 * @param l
	 */
	void addToIndex(vector<word> words, file f, line_number l);
	
	/**
	 * Add a new Word and return the iterator to that position.
	 * If the word is in map already, then return the iterator with position of that word.
	 * @return map<word, map_files>::iterator with the position of the word in map.
	 */
	words::iterator addWord(word w);
	
	/**
	 * Add a file to a word and returns the iterator to the position of the file key
	 * If the file is already in map, then the iterator points to that file.
	 * 
	 * @param it the iterator pointing to the word where the fill will be added.
	 * @return map<file, list<line> >::iterator pointing to the file.
	 */
	files::iterator addFile(words::iterator it, file f);
	
	/**
	 * Adds a line to a given file (iterator).
	 * @param file_it
	 * @param l
	 * @return
	 */
	void addLine(files::iterator file_it, line_number l);
	
	
	// Check if word is correct:
	
	/**
	 * Check if the word is valid.
	 * @param w
	 * @return bool
	 */
	bool isWordValid(word w);
	
	/**
	 * Check if character is a valid character.
	 * @param c
	 * @return bool
	 */
	bool isCharValid(char c);
	
	/**
	 * Check if the character is valid to be the first character of the word.
	 * @param c
	 * @return bool
	 */
	bool isFirstCharValid(char c);
	
	/**
	 * Removes invalid characters at the beginning of the word.
	 * @param word The word to be corrected.
	 */
	void correctWord(string &word);
	
	
	// Get information about the index:
	
	/**
	 * Get a string with the index of all words.
	 * @return string
	 */
	string allToString();
	
	/**
	 * Convert a word at current iterator position to string. This includes all files and line numbers.
	 * Use fileToString()
	 * @parma w_it The current iterator,
	 * @return string String representation of the word and all files and lines where it occurs.
	 */
	string wordToString(words::iterator w_it);
	
	/**
	 * Converts a file at current iterator position to string. This includes all lines.
	 * Use line_numberToString()
	 * @param f_it The current iterator.
	 * @return string String representation of file and all lines.
	 */
	string fileToString(files::iterator f_it);
	
	/**
	 * Converts a line number at current iterator position to string.
	 * @param l_set The current iterator.
	 * @return string String representation of this line number.
	 */
	string line_numberToString(line_numbers::iterator l_set);

public:
	/**
	 * Create an object.
	 */
	Index();
	
	/**
	 * Destroy the object.
	 */
	~Index();	
	
	/**
	 * This method insert a word occuring in a file at a line to the index.
	 * @param w The word to insert to the index.
	 * @param f The file the word occurs in.
	 * @param lines The line in the file where the word occurs.
	 */
	void addToIndex(word w, file f, line_numbers lines);
	
	/**
	 * Create a new Index.
	 * @param out The outputfile to write the index in.
	 * @param in_files Reads from these input files to create an index.
	 */
	void createIndex(file out, vector<file> in_files);
	
	/**
	 * Prints the index for the given word.
	 * Called with parameter -q
	 * @param w The word the index is printed for.
	 */
	void printIndexForWord(word w);
	
	/**
	 * Print all words which matches with the first characters the given string.
	 * Called with parameter -s
	 * @param characters The letters the word must fit at the beginning.
	 */
	void printWordsMatchesCharactersAtBeginning(string characters);
	
	/**
	 * Print all words which matches the given string anywhere.
	 * This is not a required method! Called with parameter -s
	 * @param characters The characters to find in the index.
	 */
	void printWordsMatchesCharactersAnywhere(string characters);
	
	/**
	 * Print all words in given file in shell.
	 * Called with parameter -t
	 * @param f Print all words occuring in the given file.
	 */
	void printIndexForFile(file f);
	
	/**
	 * print the index for a given outputfile.
	 * Called with parameter -p
	 * @param out_file The output file to be printed.
	 */
	void printIndexFromOutputFile(file out_file);
};

#endif	/* _INDEX_H */
