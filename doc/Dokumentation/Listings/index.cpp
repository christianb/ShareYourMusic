using namespace std;

#include "index.hpp"

void Index::init() {
	// create new map
	this->_word_index = new words();
	this->s_util = new StringUtil();
}

Index::Index() {
	this->init();
}

Index::~Index() {
	for (words::iterator w_it = _word_index->begin(); w_it != _word_index->end(); w_it++) {
		files *f_map = w_it->second; 
		
		for (files::iterator f_it = f_map->begin(); f_it != f_map->end(); f_it++) {
			line_numbers *l = f_it->second;
			delete l; 
		}
		
		delete f_map;
	}
	
	delete _word_index;
	
	delete s_util;
}

void Index::createIndex(file out, vector<file> in) {	
	//cout << "call createIndex()" << endl;
	
	
	this->readContent(in);
	this->writeContent(out);
}

void Index::readContent(vector<file> files) {
	/*//cout << "call readFiles()" << endl;
	for (vector<file>::iterator f_it = files.begin(); f_it != files.end(); f_it++) {
		this->readFile(*f_it);
	}*/
		map<string, vector<string>* > file_content_map = this->f_util->readFiles(files);
		
		// NOW WE HAVE ALL FILES AND THEIR LINES
	for (map<string, vector<string>*>::iterator f_c_it = file_content_map.begin(); f_c_it != file_content_map.end(); f_c_it++) {
		string current_file = f_c_it->first;
		vector<string> *lines = f_c_it->second;
		
		int line_number = 0;

		// for each line in vector
		for (vector<string>::iterator line_it=lines->begin() ; line_it != lines->end() ; line_it++) {
			string line = *line_it;

			// extract all words from line
			vector<string> words = this->extractAllWordsFromLine(line);

			// now we can insert all the words, from current line, from current file in map
			this->addToIndex(words, current_file, ++line_number);
		}
	}
}

void Index::writeContent(string out_file) {
	this->f_util->writeFile(out_file, this->allToString());
}

bool Index::isWordValid(word w) {
	//cout << "call isWordValid(" << w << ")" << endl;
		
	int i = 0;
	for (string::iterator word_it=w.begin(); word_it != w.end(); word_it++) {
		// check first char if it is valid
		if (i == 0) {
			if (!this->isFirstCharValid(*word_it)) {
				//cout << "first char is not valid!" << endl;
				//cout << "return false" << endl;
				return false;
			} 
		} else {
			// all other characters, not at first, check if they're valid
			if (!this->isCharValid(*word_it)) {
				//cout << "some char in word is not valid" << endl;
				//cout << "return false" << endl;
				return false;
			}
		}
		i++;
	}
	
	//cout << "return true" << endl;
	return true;
}

bool Index::isCharValid(char c) {
	//cout << "call isCharValid(" << c << ")" << endl;
	// alternative implementation
	if ( this->isFirstCharValid(c) || (c >= '0' && c <= '9')  || c == '-') {
		return true;
	}
	
	return false;
}

// check the first character
bool Index::isFirstCharValid(char c) {
	if ( (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_') {
		return true;
	}
	
	return false;
}

vector<word> Index::extractAllWordsFromLine(string line) {
	vector<string> words; 
	
	string *word = new string();
	
	// for each character in line
    for (string::iterator char_it=line.begin(); char_it!=line.end(); char_it++) {
		//cout << "call for each character in line, char: " << *char_it << endl;
		
		// if it is a valid character
		if (this->isCharValid(*char_it)) {
			#ifdef Lexic_Compare
				word->push_back(*char_it);
			#else
				word->push_back(tolower(*char_it));
			#endif
		} else {
			
			// copy word in vector
			if (word->size()>0) {
				words.push_back(*word);
				word->clear();
			}
			continue;
		}
    }
	
	if (word->size()>0) {
		words.push_back(*word);
	}
	
	delete word;

	vector<string> validWords;
	// now we have all words from line, but now we have to check if all words starts with a valid char
	for (vector<string>::iterator w_it = words.begin(); w_it != words.end(); w_it++) {
		string word = *w_it; // get the word
		
		// here we can decide if we want to remove wrong words, or to correct them
		
		// if the word is not valid, correct it
		if (!this->isWordValid(word)) {
			this->correctWord(word);
			
			// if the word is empty (no valid first character up to the end of the word)
			if (word.empty()) {
				continue; // go on with next word
			}
		}

		// now we have an absolut correct word, at to vector.
		validWords.push_back(word);
	}
	
	return validWords;
}

void Index::correctWord(string &word) {
	// remove all invalid chars at beginning
	for (string::iterator s_it = word.begin(); s_it != word.end(); s_it++) {
		char c = *s_it;

		// if the character is valid
		if (this->isFirstCharValid(c)) { 
			word.assign(s_it, word.end());
			return;
		}
	}
	
	// if none character is valid for first sign, so the word can not be correct, 
	// beacause there is no other character left 
	word.clear();
}

void Index::addToIndex(vector<string> words, file f, line_number l) {
	
	for (vector<string>::iterator words_it=words.begin() ; words_it != words.end() ; words_it++) {
		this->addToIndex(*words_it, f, l);
	}
}

/**
 * Adds a word to the map.
 * If the word already exists, append values.
 */
void Index::addToIndex(word w, file f, line_number l) {
 	//cout << "call addToIndex, word: " << w << ", in file: " << f << ", at line: " << l << endl;	
	
	// the word is in the map and we get an iterator to its position.
	words::iterator word_it = this->addWord(w);
	
	// now we can add the file to that word
	files::iterator file_it = this->addFile(word_it, f);
	
	// now we can add the line to the given file iterator
	this->addLine(file_it, l);	
}

words::iterator Index::addWord(word w) {
		// change word to lower case
		//this->s_util->toLowerCase(w);
	
		pair<words::iterator,bool> ret;
		files *f = new files();
		
		/*cout << "  find " << w << " in map -> ";
		words::iterator w_it = _word_index->find(w);
		if (w_it != _word_index->end()) {
			cout << "true" << ", " << w_it->first << " is in map!" << endl;
		} else {
			cout << "false" << endl;
		}*/
		
		ret = _word_index->insert(pair<word, files*>(w, f));
		
		if (ret.second == false) {
			//cout << ret.first->first << " is already in map!" << endl;
			delete f;
		}
		
		return ret.first;
}

files::iterator Index::addFile(words::iterator word_it, file f) {
	// get the value (map_files) from iterator
	files *m_files = word_it->second;

	pair<files::iterator,bool> ret;
	line_numbers *l = new line_numbers();
	ret = m_files->insert(pair<file, line_numbers* >(f, l));
	
	if (ret.second == false) {
		//cout << "file: '" << f << "' is already in map for the word: " << word_it->first << " so no changes!" << endl;
		delete l;
	}
	
	return ret.first;
}

void Index::addLine(files::iterator file_it, line_number l) {
	//cout << "add line number : " << l << " to file : " << file_it->first << endl;
	file_it->second->insert(l);
}

vector<string>* Index::readAllLines(file f) {
	// read the given index file
	// this vectore stores each line in the file
	vector<string> *lines = new vector<string>();
	string line;
	
	// read from inputfile
	ifstream in(f.c_str());
		
	// test if file exist
	if (!in) {
		cout << "Eingabedatei "<< f << " nicht gefunden!" << endl;
		in.close() ; // Datei schließen
		return lines;
	}
	
	// read each line of file
	while (getline(in, line, '\n')) {
		// put line at the end of vector.
	    lines->push_back(line);
	}
	
	in.close() ; // Datei schließen
	
	return lines;
}

void Index::printIndexFromOutputFile(file f) {
	cout << "printIndexFromOutputFile : " << f << endl;

	cout << this->allToString();
}

string Index::allToString() {
	string all;
	for (words::iterator w_it = _word_index->begin(); w_it != _word_index->end(); w_it++) {
		all.append(this->wordToString(w_it));
	}
	
	return all;
}

string Index::wordToString(words::iterator w_it) {
	//words::iterator w_it = _word_index->find(w);
	string word;
	word.append(w_it->first);

	files *f_map = w_it->second;
	for (files::iterator f_it = f_map->begin(); f_it != f_map->end(); f_it++) {
		word.append(this->fileToString(f_it));
	}

	return word;
}

string Index::fileToString(files::iterator f_it) {
	string files;
		files.append(" ");
		files.append(f_it->first);
		
		line_numbers *l_set = f_it->second;
		for (line_numbers::iterator l_it = l_set->begin(); l_it != l_set->end(); l_it++) {
			files.append(this->line_numberToString(l_it));
		}
		
		files.append("\n");
	
	return files;
}

string Index::line_numberToString(line_numbers::iterator l_it) {
	string lines;
		lines.append(" ");
		lines.append(this->s_util->toString(*l_it));
	
	return lines;
}

// print the Index for one word.
// TODO, can be used for other methods
void Index::printIndexForWord(string pWord) {
	// find given word	
	words::iterator w_it = _word_index->find(pWord);
	
	// if word is in map
	if (w_it != _word_index->end()) {
		cout << this->wordToString(w_it);
	} else {
		cout << "The word: " << pWord << " is not an element of the index!" << endl;
	}
}

void Index::printWordsMatchesCharactersAtBeginning(string chars) {
	for (words::iterator w_it = _word_index->begin(); w_it != _word_index->end(); w_it++) {
		string word = w_it->first;
		size_t found;
		found = word.find(chars);
		
		if (found == 0) {
			cout << this->wordToString(w_it);
		}
	}
}

void Index::printWordsMatchesCharactersAnywhere(string chars) {	
	for (words::iterator w_it = _word_index->begin(); w_it != _word_index->end(); w_it++) {
		string word = w_it->first;
		
		size_t found;
		found = word.find(chars);
		
		//cout << "found word: " << chars << " at position: " << found << endl;
		if (found!=string::npos) {
			cout << this->wordToString(w_it);
		}
	}
}

void Index::printIndexForFile(file f) {
	for (words::iterator w_it = _word_index->begin(); w_it != _word_index->end(); w_it++) {
		word w = w_it->first;
		files *f_map = w_it->second;
		
		files::iterator f_it = f_map->find(f);
		if (f_it != f_map->end()) {
				cout << w << this->fileToString(f_it);
			}
	}
}

void Index::addToIndex(word w, file f, line_numbers lines) {
	for (line_numbers::iterator l_it = lines.begin(); l_it != lines.end(); l_it++) {
		this->addToIndex(w, f, *l_it);
	}
}
