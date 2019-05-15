# Curl

## GET

Unless explicitly specified otherwise, the use of the option `--data-urlencode` causes Curl to perform a POST request. In order to force Curl to perform a GET request, you must set the option `-G`.

    curl -s -u login:password \
         -H "Accept : application/json"
         -G \
         --data-urlencode "name=${PROJECT_NAME}" \
         --data-urlencode "project=${PROJECT_KEY}" \
         http://server/rest/api/entry_point 

> Do **NOT** use the option `-X GET`:
>
> This option only changes the actual word used in the HTTP request, it does not alter the way curl behaves. So for example if you want to make a proper HEAD request, using `-X` HEAD will not suffice. You need to use the `-I`, `--head` option. 
> 
> `--data-urlencode <data>` : this posts data, similar to the other `-d`, `--data` options with the exception that this performs URL-encoding.
>
> `-G` : when used, this option will make all data specified with `-d`, `--data`, `--data-binary` or --data-urlencode to be used in an HTTP GET request instead of the POST request that otherwise would be used. The data will be appended to the URL with a '?' separator.

## POST

Unless explicitly specified otherwise, the use of the option `--data-urlencode` causes Curl to perform a POST request.

    curl -s -u login:password \
         -H "Accept : application/json"
         --data-urlencode "name=${PROJECT_NAME}" \
         --data-urlencode "project=${PROJECT_KEY}" \
         http://server/rest/api/entry_point  
