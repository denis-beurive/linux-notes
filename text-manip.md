# Text manipulation

Remove:
* blank lines (`^\s*$`).
* lines that start with "`#`" (`^\s*#`).

```
sed -r '/^\s*#/d; /^\s*$/d' /path/to/file.txt
```

