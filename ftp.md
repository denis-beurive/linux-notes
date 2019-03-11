# FTP

## FTP from the CLI

    FTP_HOST=hostnaùe
    FTP_USER=username
    FTP_PASS=password

    touch test
    (
       echo "
           open ${FTP_HOST}
           user ${FTP_USER} ${FTP_PASS}
           binary
           put test
           close
       "
    ) | ftp -dvin



