# Expect

## Automate GIT cloning

```
#!/usr/bin/expect
#
# ./cloner https://...

set LOGIN {your-login}
set PASSWORD {your-password}
set REPOSITORY [lindex $argv 0]

spawn git -c http.sslVerify=false clone $REPOSITORY
expect -exact {Username for}
send -- "$LOGIN\r"
expect -exact {Password for}
send -- "$PASSWORD\r"
set timeout -1  ; 
```

