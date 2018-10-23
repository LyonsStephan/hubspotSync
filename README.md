# hubspotSync
Manipulation of hub spot API to sync contacts to other systems
Author: Slyons
On behalf of interlaced 2018
#########

10/2/2018 - Currently the script will recover all contacts found in the demo Hubspot API via parsing the JSON get response, and return data in a single spaced text file. 
Current content: firstName, lastName
#########

10/22/2018 - No further changes necessary. This will be the last push to development.
API key has been variablized and dummy API key has been inserted.
Comments have been added for clarity and future expansion.

If miscellaneous fields need to be gathered;
Line 8:  Continue to trim through JSON output to find value. 
Line 22: Create Array for value added to Line 8.
Line 37: Duplicate logic from above into the loop.
#########

10/22/2018 - Merged into Master.
#########