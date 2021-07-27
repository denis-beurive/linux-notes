# Find tricks

Sometimes you only want the paths to the files that contain a pattern:

```
find / -type f -name "*" -exec grep -q 'import ' {} \; -exec echo {} \; 
```

> We want the paths to the files that contain the pattern "`import `".
