# Screen

## Display organisation

A _terminal_:

* is divided into _regions_. By default a terminal is made of only one _region_ (that covers all the terminal area).
* contains an ordered list of _windows_.

A _window_:

* is assigned to a _terminal_.
* is **NOT** assigned to a (specific) _region_. This means that you can display the same _window_ in multiple _regions_ (of the same _terminal_, of course).

## Regions management

> Note that when a _region_ (within a _terminal_) is created, it is "empty" (meaning that it is not associated with a _window_).
> * In order to create a _window_ within a newly created region: `[Crt] [a] [c]` (_create a new window_).
> * You can also associate an existing _window_ to the _region_: `[Crt] [a] ["]` ...

* `[Crt] [a] [Maj] [S]`: split a region horizontally. Note: to get a new _window_: `[Crt] [a] [c]`. To display an existing _window_: `[Crt] [a] ["]` ...
* `[Crt] [a] [|]` or `[Crt] [a] :split`: split a region vertically. Note: to get a new _window_: `[Crt] [a] [c]`. To display an existing _window_: `[Crt] [a] ["]` ...
* `[Crt] [a] [Tab]`: go the the next region.
* `[Crt] [a] :remove` or `[Crt] [a] [Maj] [X]`: remove the current region.
* `[Crt] [a] :resize`: resize the current region.
* `[Crt] [a] :fit` or `[Crt] [a] [Maj] [F]`: if you resize the terminal, then you may need to refresh the "drawing" of the regions.

## Windows management

* `[Crt] [a] [c]`: create a new window.
* `[Crt] [a] ["]`: list all windows.
* `[Crt] [a] [Maj] [A]`: set the title.
* `[Crt] [a] [k]`: destroy (kill) the current window.

## Moving around

* `[Crt] [a] [n]`: next window, relatively to the windows order.
* `[Crt] [a] [p]`: previous window, relatively to the windows order.
* `[Crt] [a] [Crt] [A]`: previously visited window.

## Rename the session

```bash
screen -S <old id> -X sessionname <new id>
```

## Scroll / copy from the current window

### Scroll

Enable **scrolling mode**. In this mode you can scroll backward and forward using the arrow keys (or the mouse wheel):

* `[Crt] [a] [Esc]`: enter "scrolling mode". Once un "scrolling mode":
   * `[Crt] [u]`: scroll up
   * `[Crt] [d]`: scroll down

> To exit the **scrolling mode**, just hit `Esc`.

### Copy some text

While the **scrolling mode**:

* Start text selection: hit `Space bar`
* Select text: use the arrow keys to select the text to copy.
* End text selection (copy the selected text): hit `Space bar`.

> Once the text has been copied you can exit the **copy mode** (just hit `Esc`).

## Copy text from a well konwn file

Hit `[Crt] [a] [<]`: this will copy the text from a _well konwn file_ (this file should be `/tmp/screen-exchange`).

## Paste previously selected text

### Past into the current window

Hit `[Crt] [a] []]`.

### Paste into a well konwn file

Hit `[Crt] [a] [>]`.

> Note that you cannot choose the path to the file (it should be `/tmp/screen-exchange`).

## Screen management

* `[Crt] [a] [d]`: detach screen from the terminal. Reactach with `screen -R [<session ID>]`.
* `[Crt] [a] :quit`: end the current sesssion. This command will terminate all windows.
* `[Crt] [a] [x]`: lock a screen.
* `screen -ls`: list the running screen session. This command prints the list of session IDs.
* `screen -R [<session ID>]`: reactach a (detached) screen to the terminal.
* `screen -c <config file>`: start a screen using a configuration file.
* `screen -S <old name> -X sessionname <new name>`: rename a screen session.

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

## Customize the SCREEN ID

```bash
screen -S YourName
```

## Load the BASH environment at startup

```bash
screen /bin/bash --init-file ~/.bash_profile
```

> Of course, you can also customize the SCREEN ID: `screen -S YourName /bin/bash --init-file ~/.bash_profile`

Useful function:

```bash
function myscreen {
  local -r _name="${1}"
  screen -S "${_name}" /bin/bash --init-file ~/.bash_profile
}
```

> Put this function into the BASH init file.

## Links

* [Screen User’s Manual](https://www.gnu.org/software/screen/manual/screen.html)
* [GNU Screen](https://wiki.archlinux.org/index.php/GNU_Screen#Use_256_colors)

## Troubleshooting

### Cannot open your terminal '/dev/pts/0' - please check

See [this document](https://makandracards.com/makandra/2533-solve-screen-error-cannot-open-your-terminal-dev-pts-0-please-check).

