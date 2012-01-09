using namespace std;

#include "indexparser.hpp"

IndexParser::IndexParser(Index *i) {
	this->index = i;
}

IndexParser::~IndexParser() {
}

// Store each line from selected index_file into given vector<string>
void IndexParser::fileToLines(vector<string> *lines, string index_file){
	ifstream in(index_file.data()) ; // Open given IndexFile	
	string line;

	// Test if file exist. If exists --> store lines in verctor<string>
	if (!in){
		cout << "Index file:  "<< index_file << " not found!" << endl;
		in.close() ; // Datei schließen
	}
	else{
		// Read each line of given index file
		while (getline(in, line, '\n')) {
		lines->push_back(line); // Put line at the end of vector.
		}
	}
	in.close() ; // Close IndexFile
}

string IndexParser::parseLine(string linie, bool flag_wort, bool flag_file, bool flag_index, string last_word){
	string wort, file, ind;
	stringstream out;
	int index = 0;	
	line_numbers *index_set = new line_numbers();

  	// Parse given line and differ strings between WORD, FILE and INDEX
	for (string::iterator s_it = linie.begin(); s_it != linie.end(); s_it++) {
		out.str("");
		out << *s_it;
		string character = out.str();
		StringUtil s_util; 

		// Read rest --> INDEX
		if (flag_wort == true && flag_file == true && flag_index == false && character != " ") {
			ind += character;
		}
		// Insert parsed index into index set
		if ((flag_wort == true && flag_file == true && flag_index == false && character == " " && ind != "") || (s_it == linie.end()-1)) {
			out.str(ind);
			s_util.stringTo(out.str(), index);
			index_set->insert(index);
			out.str((ind = ""));
		}

		// Read second string --> FILE
		if (flag_wort == true && flag_file == false && flag_index == false && character != " ") {
			file += character;	
		}
		// Set respective flag if file name extracted	
		if (flag_wort == true && flag_file == false && flag_index == false && character == " ") {
			flag_file = true;
		}

		// Read first string --> WORD
		if (flag_wort == false && flag_file == false && flag_index == false && character != " ") {
			wort += character;		
		}
		// Set flag if the first word is completely extracted.
		// Set flag also when the first charakter is BLANK. IT means --> word == previous word and first string is a file name
		if (flag_wort == false && flag_file == false && flag_index == false && character == " " && (s_it != linie.begin()) ) {
			flag_wort = true;		
		}
		// If first charakter is BLANK then use previous word and the next string will be a file name
		if (flag_wort == false && flag_file == false && flag_index == false && character == " " && (s_it == linie.begin()) ) {
			wort = last_word;
			flag_wort = true;		
		}
	}
	
	
	this->index->addToIndex(wort, file, *index_set);
	/*
	// TEST FUNKTION ZUR AUSGABE AM TERMINAL
	cout << wort << " " << file << " ";
	for (set<int>::iterator line_it = index_set->begin(); line_it != index_set->end(); line_it++) {
		// write out line number followed by a BLANK 
		stringstream o;
		o << *line_it;
		string line = o.str();
		cout << *line_it << " ";
	}
	cout << "\n";
	// ENDE DER TESTFUNKTION*/
	delete index_set;
	return wort;
}

void IndexParser::parseAllLines(vector<string> *lines){
	string linie;
	string last_word = "";

	// Read each line of file and parse it
	for (vector<string>::iterator lines_it = lines->begin(); lines_it != lines->end(); lines_it++) {
		bool flag_wort = false;	// Flag flag_word==true when the word of current line is parsed
		bool flag_file = false;	// Flag flag_file==true when file name of current line is parsed
		bool flag_index = false; // Flag flag_index==true when every index of current line is parsed
		stringstream out;
		out << *lines_it;
		linie = out.str();
		// Parse current line and write values into the index; Use flags to mark parsing progress
		last_word = this->parseLine(linie, flag_wort, flag_file, flag_index, last_word);
	}
}

void IndexParser::readIndexFile(string index_file) {
	vector<string> *lines = new vector<string>();  // vector<string> for text lines 
	this->fileToLines(lines, index_file);	// store each line as a string in vector<string
	this->parseAllLines(lines);	// parse every line and put the extracted data into index
	delete lines;
}


