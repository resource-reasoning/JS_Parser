import os.path
from os import walk
import sys
import time
import fnmatch

def run_parser(folder):

    os.system("mkdir -p " + folder+"_JSIL")
    for dirpath, dirnames, filenames in walk(folder,topdown=True):
        files = fnmatch.filter(filenames, '*.js')
        file_number = len(files)
        if folder == dirpath:
            prefix = "_base"
        else:
            flen = len(folder)
            dlen = len(dirpath)
            start = flen - dlen
            prefix = dirpath[start:]
        prefix = prefix.replace("/", "_")
        print (prefix)
        print ("RUNNING PARSER FOR %d FILES") % (file_number)
        for js_file in files:
            filename = (js_file.rsplit(".", 1))[0]
            filename = filename.replace(".", "_")
            print ('\nrunning parser for '+js_file+'\n')
            os.system("./JSParserConsole.native -file "+ dirpath+"/"+js_file+" -output "+folder+"_JSIL/"+prefix+"_"+filename+".js") 

if __name__ == "__main__":
    folder = sys.argv[1]
    run_parser(folder)	
