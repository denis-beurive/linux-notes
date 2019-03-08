# Unity application launcher

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

