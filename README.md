# CIO DBseeker
Shell Scripts intitially written for downloading CIOdc medication catalog and building an sqlite3 DB for easy browsing of the catalog.  

## What is CIO(dc)? 
CIOmed ([CIOdc](http://www.phast.fr/ciodc/) & CIOdm) collects data from many official sources and processes it in a standard format to support hospital practices around the medication circuit. It is provided by [Phast](https://www.phast.fr/about-phast-2/).

## Why importing the plain text files into a DB?
For some reason, I need tu use the plain text mode of CIOdc (that is also available using more modern ways).  
Plain text files are a pain in the neck to read, and browse by hand : thus the need to import them into a DB that can be queried easily.

## gathering data
### PowerShell
input : user and password  
URL target is hardcoded in script for now.

### Shell
input : none  
URL, user and password are hardcoded in script for now
