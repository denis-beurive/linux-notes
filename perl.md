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

sub custom_cmp_files {
    my ($a, $b) = @_;
    return $a cmp $b;
}

sub loopDir {
   my ($dir, $margin) = @_;
   chdir($dir) || die "Cannot chdir to \"${dir}\"\n";
   local(*DIR);
   opendir(DIR, ".");
   my @files = ();
   while (readdir(DIR)) { push(@files, $_); }
   closedir(DIR);
   @files = sort {custom_cmp_files($a, $b)} @files;
   foreach (@files) {
      next if ($_ eq "." || $_ eq "..");
      next if (SKIP_HIDDEN && $_ =~ m/^\./);
      printf "%s%s\n", $margin, -f $_ ? "* ${_}" : "+ ${_}:";
      if (-d $_) {
         &loopDir($_,$margin."   ");
      }
   }

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
