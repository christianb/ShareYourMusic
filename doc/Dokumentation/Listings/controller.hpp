#ifndef _CONTROLLER_H
#define _CONTROLLER_H

//#include <algorithm>

#include "cmdline.hpp"
#include "index.hpp"
#include "indexparser.hpp"

using namespace std;

/** Class Controller
 *
 *  This class controlls the flow of this programm.
 *
 *  author  Alexander Miller, Christian Bunk
 *  date    3.5.2011
 *  version 0.1
 */
class Controller {
private:

public:
	/**
	 * Takes the paramters from main function call.
	 * @param argc Nummber of parameters.
	 * @param argv[] Array with c-strings with all given paramters.
	 */
	Controller(int argc, char *argv[]);
	
	/**
	 * Destructor.
	 */
	~Controller();
	
private:
	
	/**
	 * Print help information about how to use this program.
	 */
	void printHelp();
	
};

#endif	/* _CONTROLLER_H */
