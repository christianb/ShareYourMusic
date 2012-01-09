#ifndef _CMDLINE_H
#define _CMDLINE_H

#include <vector>
#include <iterator>
#include <string>
#include <map>
#include <iostream>
//#include <sstream>

using namespace std;

typedef map<string, string> options; // Options are strings. Each option can have a value 
typedef vector<string> arguments; // A List with arguments.

/** Class CmdLine
 *
 *  This class split the command line parameters into options and arguments.
 *
 *  author  Christian Bunk
 *  date    3.5.2011
 *  version 0.1
 */
class CmdLine {
private:	
	options *opt; // Alle Parameter die mit einem Bindestrich beginnen wie: "-p"
	arguments *arg; // alle anderen Parameter ohne Bindestrich, z.B. Dateinamen "Index.txt"
	
	void insertToOptions(string option, string value);

public:
	/**
	 * Create new CmdLine.
	 * @param argc number of parameter.
	 * @param argv parameter in an array.
	 */ 
	CmdLine(int argc, char *argv[]);
	
	/**
	 * Destructor.
	 */
	~CmdLine();
	
	/**
	 * Print all options.
	 */
	void printOptions();
	
	/**
	 * Print all Arguments.
	 */
	void printArguments();
	
	/**
	 * Return the options in a map.
	 * @return map<string, string> The option with a value. The value is optional.
	 */
	map<string,string> getOptions();
	
	/**
	 * Return the arguments in a vector.
	 * @return vector<string> The arguments in a vector.
	 */
	vector<string> getArguments();
};

#endif	/* _CMDLINE_H */