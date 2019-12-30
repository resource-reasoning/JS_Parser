import os.path
from os import walk
import sys
import time
import fnmatch

def run_parser(folder):

    os.system("mkdir -p " + folder+"_parsed")
    for dirpath, dirnames, filenames in walk(folder,topdown=True):
        files = fnmatch.filter(filenames, '*.js')
        file_number = len(files)
        flen = len(folder)
        dlen = len(dirpath)
        start = flen - dlen
        prefix = dirpath[start:]
        prefix = prefix.replace("/", "_")
        print (prefix)
        print ("RUNNING PARSER FOR %d FILES") % (file_number)
        for js_file in files:
            print ('\nrunning parser for '+js_file+'\n')
            os.system("./JSParserConsole.native -file "+ dirpath+"/"+js_file+" -output "+folder+"_parsed/"+prefix+"_"+js_file) 

if __name__ == "__main__":
    folder = sys.argv[1]
    run_parser(folder)	
