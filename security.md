# Security

## Good password manager software

[Universal Password Manager](http://upm.sourceforge.net/index.html)

**Configuration file**

See [this link](http://upm.sourceforge.net/upm_swing_userguide.html#config_file). Under Linux: `$HOME/.config/upm.properties`.

**Export (backup) passwords**

`Database ⇒ Export`

> **WARNING**: you can export the password database. However, be aware that the exported file is not encrypted.

**How to restore an export**

Let's say that:

* you want to restore the export `/path/to/the/export/file`.
* you decide that the path to the new UPM database will be: `/path/to/the/new/database`.

Follow the procedure below:

* Close the UPM application.
* Start the UPM application.
* `Database ⇒ New Database`: enter the path to a file that will be used to hold the new database. That is: `/path/to/the/new/database`
* Close the UPM application.

> At this point, you've just created a (new) empty database (`/path/to/the/new/database`).

* Edit the configuration file for the UPM application (`$HOME/.config/upm.properties`). Set the value of the property `DBToLoadOnStartup` to `/path/to/the/new/database`.

* Start the UPM application.
* Enter a password.
* `Database ⇒ Import`: select the file that contains the data to import (`/path/to/the/export/file`).

## Encrypt / Decrypt a file using AES-256

### Without password in the command line

Encrypt:

    openssl enc -aes-256-cbc -in /path/to/the/file/to/encrypt -out /path/to/the/encrypted/file

Decrypt:

    openssl enc -d -aes-256-cbc -in /path/to/the/encrypted/file -out /path/to/the/decryted/file

### Specify the password in the command line

Encrypt:

    openssl enc -aes-256-cbc -pass pass:the-password -in  /path/to/the/file/to/encrypt -out /path/to/the/encrypted/file -p

Decrypt:

    openssl enc -d -aes-256-cbc -pass pass:the-password -in /path/to/the/encrypted/file -out /path/to/the/decryted/file -p

## Antivirus

Clam AV: [https://www.makeuseof.com/tag/command-line-clam-antivirus-linux/](https://www.makeuseof.com/tag/command-line-clam-antivirus-linux/)

    sudo apt-get install clamav clamav-freshclam

Refresh the database of viruses signatures:

    sudo freshclam

Scan a directory recursively:

    sudo clamscan -r /home/
    
or:

    sudo clamscan -ri /home/

> The option "i" tells Clam to print the paths of infected files only.

