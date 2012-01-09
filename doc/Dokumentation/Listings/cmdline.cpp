
using namespace std;

#include "cmdline.hpp"

CmdLine::CmdLine(int argc, char *argv[]) {	
	opt = new options;
	arg = new arguments;

	// if there is at least one parameter
	if (argc > 1) {
		size_t found_minus;
		
		// go through each parameter
		for (int i = 1; i < argc; i++) {	
			// get next parameter
			string parameter = string(argv[i]);
			string::iterator p_it = parameter.begin();
		
			// now ceck all characters of parameter
			
			// if param is an option
			found_minus = parameter.find('-');
			
			if (found_minus == 0) {
				// check if there is an equal sign
				size_t found_equal = parameter.find('=');
				
				// if there is an equal sign
				if (found_equal != string::npos) {
					string option;
					option.assign(parameter, 1, found_equal-1);
					
					string value;
					value.assign(parameter, found_equal+1, string::npos);
					this->insertToOptions(option, value);
				} else {
					// if there is now equal sign
					string option;
					option.assign(parameter, 1, string::npos); // leave the minus, and get all character after minus til the end
					
					// insert option to map with no value
					this->insertToOptions(option, "");
				}
				
				
			} else {
				this->arg->push_back(parameter);
			}
		}
	}
}

CmdLine::~CmdLine() {
	delete opt;
	delete arg;
}

void CmdLine::insertToOptions(string option, string value) {
	this->opt->insert(pair<string,string>(option, value));
}

void CmdLine::printOptions() {
	for (map<string, string>::iterator m_it = opt->begin(); m_it!=opt->end(); m_it++) {
	    cout << "key: " << m_it->first << "; value: " << m_it->second << endl;
	}
}

void CmdLine::printArguments() {
	for (vector<string>::iterator it = arg->begin(); it!=arg->end(); ++it) {
	    cout << *it << endl;
	}
}

map<string,string> CmdLine::getOptions() {
	return *opt;
}

vector<string> CmdLine::getArguments() {
	return *arg;
}
