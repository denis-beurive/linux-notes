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

Or, this script may be interesting:

    #!/usr/bin/env bash

    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
    readonly __DIR__="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

    config=$(cat <<"EOS"
    altscreen on

    chdir "${__DIR__}/www"
    screen -t "www" 1

    chdir "${__DIR__}/tools"
    screen -t "data" 2

    chdir "${HOME}"
    screen -t "${HOME}" 3

    chdir "${HOME}"
    screen -t "root@${HOME}" 4

    EOS
    )

    eval "readonly conf=\"${config}\""
    echo "${conf}" > /dev/shm/screen.rc

    screen -c /dev/shm/screen.rc && rm /dev/shm/screen.rc

### Slightly advanced configuration

This configuration creates 4 regions vertically stacked on top of each others.

* the first region display the content of the file `/var/log/apache2/access.log`.
* the second region display the content of the file `/var/log/apache2/error.log`.
* the third region display the content of the file `/var/log/apache2/other_vhosts_access.log`.
* the last region will receive the focus.

Configuration file:

    altscreen on

    # Create 3 windows

    # Move to the directory "/var/log/apache2".
    # Then create a new window. Assign it the index 1.
    # Execute the command "tail -f /var/log/apache2/access.log" within this window.

    chdir "/var/log/apache2"
    screen -t "access" 1 tail -f /var/log/apache2/access.log

    # Move to the directory "/var/log/apache2".
    # Then create a new window. Assign it the index 2.
    # Execute the command "tail -f /var/log/apache2/error.log" within this window.

    chdir "/var/log/apache2"
    screen -t "error" 2 tail -f /var/log/apache2/error.log

    # Move to the directory "/var/log/apache2".
    # Then create a new window. Assign it the index 3.
    # Execute the command "tail -f /var/log/apache2/other_vhosts_access.log" within this window.

    chdir "/var/log/apache2"
    screen -t "other_vhosts_access" 3 tail -f /var/log/apache2/other_vhosts_access.log

    # Move to /tmp.
    # Then create a new window. Assign it the index 4.

    chdir "/tmp"
    screen -t "commands" 4

    # Create 3 regions.
    #
    # 1. The terminal contains only one region (that occupies all the available area).
    #    This region is, de facto, the current region.
    #
    # 2. The first "split command" vertically splits the current region into 2 regions.
    #    The terminal now contains 2 regions.
    #    And the current region is the upper one (thus, the first from the top).
    #
    # 3. The second "split command" vertically splits the current region into 2 regions.
    #    The terminal now contains 3 regions.
    #    And the current region is the second from the top.
    #
    # 4. The third "split command" vertically splits the current region into 2 regions.
    #    The terminal now contains 4 regions.
    #    And the current region is the third from the top.
    #
    # That is:
    #
    #    -------------------------------------
    #    First region
    #    -------------------------------------
    #    Second region
    #    -------------------------------------
    #    Third region
    #    -------------------------------------
    #    Fourth region
    #    -------------------------------------
    #
    # At the end, the current region is the third one.

    split
    split
    split

    # Move the focus upward 2 times.
    # This makes the top region (the first one) the current region.
    # In the current region (the first one), show the first window.
    focus up
    focus up
    select 1

    # Move to the next region. And, in this region, show the second windows.
    focus
    select 2

    # Move to the next region. And, in this region, show the third windows.
    focus
    select 3

    # Move to the next region. And, in this region, show the fourth windows.
    focus
    select 4

    # At this point, the current region (the one that gets the focus) the the fourth one.

## Links

* [Screen User’s Manual](https://www.gnu.org/software/screen/manual/screen.html)
* [GNU Screen](https://wiki.archlinux.org/index.php/GNU_Screen#Use_256_colors)

## Troubleshooting

### Cannot open your terminal '/dev/pts/0' - please check

See [this document](https://makandracards.com/makandra/2533-solve-screen-error-cannot-open-your-terminal-dev-pts-0-please-check).

