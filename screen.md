# Screen

## Display organisation

A _terminal_:

* is divided into _regions_. By default a terminal is made of only one _region_ (that covers all the terminal area).
* contains an ordered list of _windows_.

A _window_:

* is assigned to a _terminal_.
* is **NOT** assigned to a (specific) _region_. This means that you can display the same _window_ in multiple _regions_ (of the same _terminal_, of course).

## Regions management

* `[Crt] [A] [Maj] [S]`: split a region horizontally.
* `[Crt] [A] [|]`: split a region vertically.
* `[Crt] [A] [Tab]`: go the the next region.
* `[Crt] [A] :remove` or `[Crt] [A] [Maj] [X]`: remove the current region.
* `[Crt] [A] :resize`: resize the current region.
* `[Crt] [A] :fit` or `[Crt] [A] [Maj] [F]`: if you resize the terminal, then you may need to refresh the "drawing" of the regions.

## Windows management

* `[Crt] [A] [C]`: create a new window.
* `[Crt] [A] ["]`: list all windows.
* `[Crt] [A] [Maj] [A]`: set the title.
* `[Crt] [A] [K]`: destroy (kill) the current window.

## Moving around

* `[Crt] [A] [N]`: next window, relatively to the windows order.
* `[Crt] [A] [P]`: previous window, relatively to the windows order.
* `[Crt] [A] [Crt] [A]`: previously visited window.

## Scroll / copy from the current window

### Scroll (enter "copy mode")

Enable **copy mode**. In this mode you can scroll backward and forward using the arrow keys (or the mouse wheel):

`[Crt] [A] [Esc]` or `[Crt] [A] [[]`

> To exit the **copy mode**, just hit `Esc`.

### Copy some text

While the **copy mode**:

* Start text selection: hit `Space bar`
* Select text: use the arrow keys to select the text to copy.
* End text selection (copy the selected text): hit `Space bar`.

> Once the text has been copied you can exit the **copy mode** (just hit `Esc`).

## Copy text from a well konwn file

Hit `[Crt] [A] [<]`: this will copy the text from a _well konwn file_ (this file should be `/tmp/screen-exchange`).

## Paste previously selected text

### Past into the current window

Hit `[Crt] [A] []]`.

### Paste into a well konwn file

Hit `[Crt] [A] [>]`.

> Note that you cannot choose the path to the file (it should be `/tmp/screen-exchange`).

## Screen management

* `[Crt] [A] [D]`: detach screen from the terminal. Reactach with `screen -R [<session ID>]`.
* `[Crt] [A] :quit`: end the current sesssion. This command will terminate all windows.
* `screen -ls`: list the running screen session. This command prints the list of session IDs.
* `screen -R [<session ID>]`: reactach a (detached) screen to the terminal.
* `screen -c <config file>`: start a screen using a configuration file.

To end a given session identified by its ID:

    screen -X -S <session ID> quit

## Typical configuration file

### Basic configuration

The text below represents a basic configuration file for `screen`.

File `screen.rc`:

    # File "screen.rc"

    # Allow editors etc. to restore display on exit
    # rather than leaving existing text in place
    altscreen on

    chdir "/home/user/projet/bin"
    screen -t "bin" 0 

    chdir "/home/user/projet/data"
    screen -t "data" 1

    chdir "/home/user/projet/tests"
    screen -t "tests" 2

It tells `screen` to open 3 windows:

* the first window will be given the title "bin". The current directory will be "`/home/user/projet/bin`".
* the second window will be given the title "data". The current directory will be "`/home/user/projet/data`".
* the third window will be given the title "tests". The current directory will be "`/home/user/projet/tests`".

Start `screen` with this configuration file:

    screen -c screen.rc

### Embed the configuration file into a BASH startup script

[this script](code/screen-1.sh) may be interesting. The screen configuration file is embedded within a bash script.

### Execute arbitrary commands at windows creations

If you want to execute arbitrary commands at windows creations, use `stuff`. For example:

    altscreen on

    screen -t "issue135-review" 0
    stuff ". venv/bin/activate; clear\n"

    chdir "tests"
    screen -t "issue135-review tests" 1
    stuff ". ../venv/bin/activate; clear\n"

    chdir "../tmp/log"
    screen -t "issue135-review log" 2
    stuff ". ../../venv/bin/activate; clear\n"

### Slightly advanced configuration

[This configuration](code/screen-1.rc) creates 4 regions vertically stacked on top of each others.

* the first region display the content of the file `/var/log/apache2/access.log`.
* the second region display the content of the file `/var/log/apache2/error.log`.
* the third region display the content of the file `/var/log/apache2/other_vhosts_access.log`.
* the last region will receive the focus.

## Links

* [Screen User’s Manual](https://www.gnu.org/software/screen/manual/screen.html)
* [GNU Screen](https://wiki.archlinux.org/index.php/GNU_Screen#Use_256_colors)

## Troubleshooting

### Cannot open your terminal '/dev/pts/0' - please check

See [this document](https://makandracards.com/makandra/2533-solve-screen-error-cannot-open-your-terminal-dev-pts-0-please-check).

