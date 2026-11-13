# CNSD UID:GID Change Script

**Compatibility:** macOS Version 1.2022+ \| RHEL / Rocky 9    
**Repository:** [GitHub \- RonSmith-Noaa/UID-change](https://github.com/RonSmith-Noaa/UID-change)  
---

## Overview

This script changes the UID/GID of a local user account or updates file ownership within a specified directory path.  
---

## Prerequisites & Installation Steps

Log on to the Mac as a local administrator.  
Grant **Full Disk Access** to Terminal:  
Go to **System Preferences** \> **Security & Privacy** \> **Privacy** \> **Full Disk Access**.  
Ensure **Terminal** is checked.  
Copy the uid\_change folder from //pesto/cnsd/ops/tools/Mac installations/ to the local admin Desktop.  
Open a Terminal window.  
Elevate to root privileges:

```sh
sudo -s
```

Navigate to the uid\_change directory:

```sh
cd ~/Desktop/uid_change
```

Run the script:

```sh
./uid_change.sh
```

---

## Script Options

### Option 1: Main Script (Change Local User Account UID/GID)

Changes the UID/GID for a specified local user account:  
Changes the account UID:

```sh
dscl . -change /Users/$USERNAME UniqueID $OLDUID $NEWUID
```

Finds and changes ownership of all files in specified paths:

```sh
find $UPATH -user $OLDUID -print0 | xargs -0 chown -h $NEWUID:$NEWGID
```

Recursively checks and updates the following default directories:  
/Users  
/Library  
/Applications  
/usr  
/private/var  
*\*Note: Additional directory paths can be added to the dirpath array within the script.\**

### Option 2: Change UID/GID in a Specified Directory

Prompts for a specific target directory path, Old UID, New UID, and GID, then executes:

```sh
find $UPATH -user $OLDUID -print0 | xargs -0 chown -h $NEWUID:$NEWGID
```
