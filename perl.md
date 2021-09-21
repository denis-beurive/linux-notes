# Perl utilities

## Perl One liner

### Read input and execute arbitrary code on the whole input

Use the option "`-e`":

```bash
cat /etc/hosts | perl -e '@v=(); while(<>) {chomp; @t=split(/\s+/, $_); push @v, $t[0]} print join(", ", @v)'
```

### Read input line by line and execute arbitrary code on each line

Use the option "`-ne`":

```bash
cat /etc/hosts | perl -ne 'chomp; @t=split(/\s+/, $_); print $t[0] . "\n"'
```

> The content of each line is given by the value of `$_`.

### Read input line by line and perform replacements on each line

Use the option "`-pe`":

```bash
cat /etc/hosts | perl -pe 's/^[^\s]+//'
```

> The option "`-pe`" is designed to be used for _replacements only_.

## Perl script

### Custom "tree" command

You can use the `tree` command to get the layout of a directory.
But if you want to include the result into a LaTex document, then you are in trouble (try it, and you will understand).

The quickest way to get your directory layout into your LaTex document is to customize this script and run it.


```perl
#!/usr/bin/perl -w
use strict;
use warnings;

use constant SKIP_HIDDEN => 1;

my ($dir) = @ARGV;
$dir = "." unless $dir;
&loopDir($dir, "");
exit;

sub loopDir {
   my ($dir, $margin) = @_;
   chdir($dir) || die "Cannot chdir to \"${dir}\"\n";
   local(*DIR);
   opendir(DIR, ".");
   while (my $f = readdir(DIR)) {
      next if ($f eq "." || $f eq "..");
      next if (SKIP_HIDDEN && $f =~ m/^\./);
      printf "%s%s\n", $margin, -f $f ? "* ${f}" : "+ ${f}:";
      if (-d $f) {
         &loopDir($f,$margin."   ");
      }
   }
   closedir(DIR);
   chdir("..");
}
```

Save this code into the file `tree.pl`.

Go to the directory you want to scan and execute the command below:

```bash
perl tree.pl
```

Other use:

```bash
perl tree.pl /path/to/directory
```
