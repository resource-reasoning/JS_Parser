import os.path
from os import walk
import sys
import time
import fnmatch

promise_header = "var assert = require(\"../harness/assert\").assert;\nvar Promise = require(\"../../../js/Promises/Promise\").Promise;\n\n"

def run_parser(folder):
    for js_file in os.listdir(folder):
        #with open(folder+js_file, 'a+') as f:
        with open(folder+js_file, "r+") as f:
            a = f.read()
            #Now writing into the file with the prepend line + old file data
            with open(folder+js_file, "w+") as f:
                f.write(promise_header + a)

if __name__ == "__main__":
    folder = sys.argv[1]
    run_parser(folder)	