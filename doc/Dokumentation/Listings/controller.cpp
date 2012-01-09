#include "controller.hpp"

Controller::Controller(int argc, char *argv[]) {
	
	// read command line parameters
	CmdLine params(argc, argv);

	map<string, string> options = params.getOptions();
	vector<string> arguments = params.getArguments();
/*
	cout << "Options: " << endl;
	params->printOptions();

	cout << endl << "Arguments: " << endl;
	params->printArguments();
*/
	// params is no longer needed
	//delete params;

	Index *index = new Index();

	#ifdef Two_Options
		if (options.size() > 1) {
			if (options.size() == 2) {
				if (options.find("p") == options.end() || options.find("i") == options.end() ) {
					cout << "Two options are only allowed with -i and -p !" << endl;
					delete index;
					return;
				}
			} else {
				cout << "Error: please type in just one option i.e. -i or -q=value" << endl;
				delete index;
				return;
			}	
		}
	#else
		// prüfen wie viele options angegeben wurden und entsprechend Meldung ausgeben
		if (options.size() > 1) {
			cout << "Error: please type in just one option i.e. -i or -q=value" << endl;
			delete index;
			return;
		}
	#endif

	if (options.empty()) {
		cout << "Error: please type in one option" << endl;
		this->printHelp();
		
		delete index;
		return;
	}

	// creates new IndexParser
	IndexParser parser(index);	

	//  create new index
	map<string,string>::iterator position = options.find("i");
	if (position != options.end()) {
		// need at least two arguments (one the output file and at least one input file)
		if (arguments.size() >= 2) {
			// read index file, so it will not be over-written
			//parser->readIndexFile(*arguments.begin());   // Previous version for parsing of existing index file
			string file = *arguments.begin();
			ifstream in(file.data()) ; // Try to open given IndexFile	
			// Test if file exist. true --> Warning and Exit the program; false --> create index and write it into the file
			if (!in){
				string out = *arguments.begin();
			
				// delete the first argument, the others are the input files
				arguments.erase(arguments.begin());

				// create the index, read the input files and write the index in the output file
				index->createIndex(out, arguments);
				in.close() ; // Datei schließen
				cout << "Created index successful written in file " << file << " \n";
			}
			else{
				cout << "Output file already existing!\n";
				in.close() ; // Datei schließen
				return;
			}
		}
		else {
			cout << "Error: not enough arguments. Need at least one output file and one input file i.e. -i out.txt in.txt" << endl;
		}	
	}
	
	// print the entire index
	position = options.find("p");
	if (position != options.end()) {
		// need at least one argument (the output file to be read in for the parser)
		if (!arguments.empty()) {
			parser.readIndexFile(*arguments.begin());
		
			// TODO: how many arguments
			index->printIndexFromOutputFile(*arguments.begin());
		}
	}
	
	// print index for the word
	position = options.find("q");
	if (position != options.end()) {
		// need at least one argument (the output file to be read in for the parser)
		if (!arguments.empty()) {
			parser.readIndexFile(*arguments.begin());
			
			cout << "suche nach dem Wort: " << position->second << endl;
			index->printIndexForWord(position->second);
		} else {
			cout << "Error: need output file as an argument i.e. -q=word out.txt" << endl;
		}
	}
	
	// print index for words who matches characters
	position = options.find("s");
	if (position != options.end()) {
		if (!arguments.empty()) {
			parser.readIndexFile(*arguments.begin());
			
			if (*position->second.begin() == '*') {
				position->second.erase(position->second.begin());
				index->printWordsMatchesCharactersAnywhere(position->second);
			} else {
				index->printWordsMatchesCharactersAtBeginning(position->second);
			}
			
			
		} else {
			cout << "Error: need output file as an argument i.e. -s=word out.txt" << endl;
		}
	}
	
	// print index file
	position = options.find("t");
	if (position != options.end()) {
		if (!arguments.empty()) {
			parser.readIndexFile(*arguments.begin());
			
			index->printIndexForFile(position->second);
		} else {
			cout << "Error: need output file as an argument i.e. -t=word out.txt" << endl;
		}
	}

	// print index file
	position = options.find("-help");
	if (position != options.end()) {
		this->printHelp();
	}
	
	//delete parser;
	delete index;
}

Controller::~Controller() {}

void Controller::printHelp() {
	cout << "********************************************************************" << endl;
	cout << "Creation and use of an associative index for program texts" << endl;		
	cout << "**********************************************************************" << endl;
	cout << "This program can be started with following command line parameters:" << endl;
	cout << "<program> <options> <outputfile> <inputfile>*" << endl;
	cout << "<program> :        Program name" << endl;
	cout << "<options> :        " << endl;
	cout << "  -p               Print index list on data terminal" << endl;
	cout << "  -i               Create an index" << endl;
	cout << "  -q=<word>        Print all indexes for word <word> on data termnal" << endl;
	cout << "  -s=<prefixterm>  Print indexes for all words with prefix term <prefixterm>" << endl;
	cout << "  -t=<filename>    Print indexes for words  founded in file <filename>" << endl;
	cout << "  --help               Description of command line parameters" << endl;
	cout << "<outputfile> :     Filename of output file with created index list" << endl;
	cout << "<inputfile>* :     List of input files for indexing" << endl;
}
