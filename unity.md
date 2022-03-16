# Unity application launcher

## Introduction

This document applies to Ubuntu `21.10`.

```bash
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 21.10"
NAME="Ubuntu"
VERSION_ID="21.10"
VERSION="21.10 (Impish Indri)"
VERSION_CODENAME=impish
```

## Adding an entry to the application launcher

To add an entry into the Unity application launcher, add a "`.desktop`" file into the directory `/usr/share/applications`. See [this link](https://help.ubuntu.com/community/UnityLaunchersAndDesktopFiles). Then reload Unity: `[Alt] + [F2]`, that `r` and `Enter`.

Example:

    #!/usr/bin/env xdg-open
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Sublime Text
    GenericName=Text Editor
    Comment=Sophisticated text editor for code, markup and prose
    Exec=/home/denis/Softwares/sublime_text_3/sublime_text %F
    Terminal=false
    MimeType=text/plain;
    Icon=/home/denis/Softwares/sublime_text_3/Icon/32x32/sublime-text.png
    Categories=Development;IDE;
    StartupNotify=true
    Actions=Window;Document;

    [Desktop Action Window]
    Name=New Window
    Exec=/home/denis/Softwares/sublime_text_3/sublime_text -n
    OnlyShowIn=Unity;

    [Desktop Action Document]
    Name=New File
    Exec=/home/denis/Softwares/sublime_text_3/sublime_text --command new_file
    OnlyShowIn=Unity;

The list of categories can be found here: [https://askubuntu.com/questions/674403/when-creating-a-desktop-file-what-are-valid-categories](https://askubuntu.com/questions/674403/when-creating-a-desktop-file-what-are-valid-categories).

> To restart Unity, you can also execute this command: `sudo service gdm restart`.
>
> To install a new desktip file, you can use this command: `sudo desktop-file-install  --dir=/usr/share/applications org.flameshot.Flameshot.desktop && echo $?`. However, there is a problem with this command. It should reload the desktop configuration so that your new configuration will be integrated. Unfortunately, this is not the case. You still need to restart the Unity desktop manager.

## Troubleshooting

Sometimes, you are not sure that a command specified by the `Exec` section is really executed when you click on the application icon. To make sure that a command is executed, you can replace it with something like: `sh -c "echo 'ok1' > /tmp/flag-file"`.

For example:

Replace `Exec=/usr/bin/flameshot` by `Exec=sh -c "echo 'ok1' > /tmp/flameshot"`.

Now, if you click on the flameshot icon, you should find the file `/tmp/flameshot`. And the file content should be "`ok1`".

> Make sure to restart the Unity desktop manager, otherwise the new configuration may be ignored !