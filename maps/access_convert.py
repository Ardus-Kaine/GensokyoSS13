from os import listdir, path
from os.path import isfile, join
import re
import sys

def main():
    if len(sys.argv) < 2:
        print('Please supply a file path.')
        return

    file_name = sys.argv[1]
    if not path.isfile(file_name):
        print('Invalid file path: ', file_name)
        return
        
    if file_name[-3:] != 'dmm':
        print('Not a dmm file.')
        return

    with open(file_name, 'r') as source:
        with open(file_name + '.new', 'w', newline='\r\n') as target:
            for line in source: 
                while(re.search(r'req_access_txt = "([^"]+);([^"]+)"', line.rstrip())):
                    line = re.sub(r'req_access_txt = "([^"]+);([^"]+)"', r'req_access_txt = "\1,\2"', line.rstrip()) 

                while(re.search(r'req_one_access_txt = "([^"]+);([^"]+)"', line.rstrip())):
                    line = re.sub(r'req_one_access_txt = "([^"]+);([^"]+)"', r'req_one_access_txt = "\1,\2"', line.rstrip()) 
                    
                line = re.sub(r'req_access_txt = "([^\"]+)"', r'req_access = list(\1)', line.rstrip())                
                line = re.sub(r'req_one_access_txt = "([^\"]+)"', r'req_one_access = list(\1)', line.rstrip())
                
                target.write(line + '\n')
    
if __name__ == "__main__":
    main()
 