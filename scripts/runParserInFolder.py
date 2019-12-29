import os.path
from os import walk
import sys
import time
import fnmatch

def run_parser(folder):
    for dirpath, dirnames, filenames in walk(folder,topdown=True):
        files = fnmatch.filter(filenames, '*.js')
        file_number = len(files)
        print ("RUNNING PARSER FOR %d FILES") % (file_number)
        for js_file in files:
            print ('\nrunning parser for '+js_file+'\n')
            os.system("./JSParserConsole.native -file "+ dirpath+"/"+js_file+" -output "+folder+"parsed/"+"new_"+js_file) 

if __name__ == "__main__":
    folder = sys.argv[1]
    run_parser(folder)	
