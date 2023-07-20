# Perl utilities

## Tips

### Set the PATH environment

Set paths to modules relatively to the path of the current file.

```perl
BEGIN {
    use File::Spec;
    sub __EXEC_DIR__ () {
        my $level = shift || 0;
        my $file = (caller $level)[1];
        File::Spec->rel2abs(join '', (File::Spec->splitpath($file))[0, 1])
    }
    use lib File::Spec->catfile(&__EXEC_DIR__(), '..', 'local');
}
```

### Declare several variables at once

```perl
use strict;
use warnings FATAL => 'all';
use Data::Dumper;

# Declare 2 variables at once
my ($var1, $var2) = (undef) x 2;

printf("%s\n", join("\n", map {defined($_) ? "defined" : "not defined"} ($var1, $var2)));
# => not defined
#    not defined
```

### Filter an array

```perl

my @array = ("a", undef, "c", undef, "d");
my @array_filtered = grep {defined} @array;
printf("\@array:          %d elements\n", int(@array));          # => @array:          5 elements
printf("\@array_filtered: %d elements\n", int(@array_filtered)); # => @array_filtered: 3 elements
print(Dumper(\@array_filtered));
# => $VAR1 = [
#               'a',
#               'c',
#               'd'
#            ];

@array = (1, 2, 3, 4);
@array_filtered = grep { $_ % 2 == 0 } @array;
print(Dumper(\@array_filtered));
# => $VAR1 = [
#               2,
#               4
#            ];
```

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

## Perl scripts

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

### Extract PKCS7 certificates from emails

```Perl
#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use MIME::Base64;

# Header must contain:
#
#   Content-Type: application/x-pkcs7-mime; smime-type=signed-data;
#       name="smime.p7m"
#   Content-Transfer-Encoding: base64
#
# or:
#
#   Content-Type: application/x-pkcs7-signature; name="smime.p7s"
#       Content-Transfer-Encoding: base64
#   Content-Disposition: attachment; filename="smime.p7s"

my $text=<<'EOS';
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
XJ/pHqF8PjqjiocUKHMJJgPcds077lUmPMNmZg==
EOS

chomp $text;
printf("INPUT:\n\n[%s]\n\n", $text);

my $data = MIME::Base64::decode($text);
open (my $fh, '>', 'b64-decoded-file') or die;
binmode($fh);
print $fh $data;
close($fh);

# Extract the certificate from the body of the email:
#
#   openssl pkcs7 -in b64-decoded-file -inform DER -print_certs -outform PEM -out certificate.pem
```

The scripts produces the file `b64-decoded-file`. From this file, you can get the certificate:

```bash
openssl pkcs7 -in b64-decoded-file -inform DER -print_certs -outform PEM -out certificate.pem
```

### Execute a module: module as a script

```bash
sub main {
    # the code to execute
}

main() if not caller();
```

> See this article: [Scripts as Modules](https://www.drdobbs.com/scripts-as-modules/184416165).

### Using threads

This script scans for (job) files ("`job.*.cmd`") within a configured directory (`&JOB_DIR`).

> The content of a job file must contain a command line used to execute a program.

When a job file is found, its content (a command line) is sent to a queue (called the "job queue"). Then the job file is removed.

Simultaneously, jobs are popped out from the (jobs) queue and executed.

The script can be used to convert a parallel execution into a sequential one.

Example: 

```bash
# file "my-job.sh".
readonly JOB_FILE="/tmp/jobs/job.${$}.cmd"
echo "/path/to/job-program" "${@}" > "${JOB_FILE}"
```


```perl
#!/usr/bin/perl
#
# Test if Perl supports threads:
# perl -e 'use Config; $Config{useithreads} or die("Recompile Perl with threads to run this program.");'

use strict;
use warnings FATAL => 'all';
use threads;
use Thread::Queue;
use File::Spec;

use constant JOB_DIR => '/tmp/jobs';
use constant JOB_LOG => '/var/log/jobs.log';
use constant POLL_PERIOD => 1;
use constant TRUE => 1==1;
use constant FALSE => 1!=1;

my $JobQueue = Thread::Queue->new();

sub exit_error {
    my ($in_message) = @_;
    printf("FATAL: %s\n", $in_message);
    exit(1);
}

$| = 1; # configure the output un auto flush.
my $t1 = threads->new(\&job_add);
my $t2 = threads->new(\&job_exec);
$t1->join();
$t2->join();

exit(0);

sub job_add {
    my $dir;

    printf("Start. Job dir is: %s\n", &JOB_DIR);
    while(&TRUE) {
        exit_error(sprintf('cannot open directory "%s": %s', &JOB_DIR, $!)) unless (opendir($dir, &JOB_DIR));
        while (readdir $dir) {
            last if ('stop' eq $dir);
            next unless ($_ =~ m/^job\..+\.cmd$/);

            my $path = File::Spec->catfile(&JOB_DIR, $_);
            my $cmd = slurp($path);
            chomp($cmd);
            printf("Add: %s\n", $cmd);
            exit_error(sprintf('error while reading file "%s"', $path)) unless (defined($cmd));
            $JobQueue->enqueue($cmd);
            exit_error(sprintf('cannot remove file "%s": %s', $path, $!)) if (1 != unlink $path);
        }
        closedir($dir);
        sleep &POLL_PERIOD;
    }

    printf("Stop\n");
}

sub job_exec {
    while (&TRUE) {
        my $job = $JobQueue->dequeue();
        my @cli = ('/bin/sh', '-c', sprintf('%s >> %s 2>&1', $job, &JOB_LOG));
        printf("Execute: %s\n", join(' ', @cli));
        system(@cli);
        if (0 != $?) {
            if ($? == -1) {
                printf("ERROR: could not execute the shell script: %s\n", $!);
            }
            elsif ($? & 127) {
                printf("ERROR: child died with signal %d, %s coredump.\n", ($? & 127), ($? & 128) ? 'with' : 'without');
            }
            else {
                printf("ERROR: child exited with value %d\n", $? >> 8);
            }
        }
        else {
            print("SUCCESS\n");
        }
    }
    printf("Stop\n");
}

sub slurp {
    my ($path) = @_;
    my ($fd, @lines);
    open($fd, '<', $path) or return(undef);
    @lines = <$fd>;
    close($fd);
    return(join('', @lines));
}
```

### Compare files

```perl
#!/usr/bin/perl
#
# Usage:
#
# perl diff.pl [--verbose] [--prefix=<prefix>] <left file> <right file>
#
# Default prefix: "diff"
#
# Generate:
#
# * <prefix>-both:       lines found in both files
# * <prefix>-only-left:  lines found in in the left file only
# * <prefix>-only-right: lines found in in the right file only

use strict;
use warnings FATAL => 'all';
use Getopt::Long;

use constant DEFAULT_PREFIX => 'diff';

my $file_left = undef;
my $file_right = undef;
my $content_left = undef;
my $content_right = undef;
my $err = undef;
my $comparison = undef;
my $output_file = undef;
my $cli_verbose = undef;
my $cli_help = undef;
my $cli_prefix = &DEFAULT_PREFIX;

# Parse the command line

GetOptions (
    'verbose'  => \$cli_verbose,
    'help'     => \$cli_help,
    'prefix=s' => \$cli_prefix
) or exit_error("invalid command line arguments\n");

if (defined($cli_help)) {
    help();
    exit(0);
}

if (2 != int(@ARGV)) {
    exit_error(sprintf("invalid command line. Expect 2 parameters, got %d\n", int(@ARGV)));
}

$file_left = $ARGV[0];
$file_right = $ARGV[1];

if (defined($cli_verbose)) {
    printf("%-25s: %s\n", 'left', $file_left);
    printf("%-25s: %s\n", 'right', $file_right);
    printf("%-25s: %s\n", 'prefix', $cli_prefix);
}

# Load the files

($content_left, $err) = slurp($file_left);
if (defined($err)) {
    exit_error(sprintf('cannot load the (left) file "%s": %s', $file_left, $err));
}
($content_right, $err) = slurp($file_right);
exit_error(sprintf('cannot load the (right) file "%s": %s', $file_right, $err)) if (defined($err));

# Compare the contents of the files

$comparison = compare($content_left, $content_right);

$output_file = sprintf('%s-both', $cli_prefix);
printf("%-25s: %s\n", 'both', $output_file) if (defined($cli_verbose));
$err = dump_data($output_file, $comparison->{both});
exit_error(sprintf('cannot create the file "%s": %s', $output_file, $err)) if (defined($err));

$output_file = sprintf('%s-only-left', $cli_prefix);
printf("%-25s: %s\n", 'only left', $output_file) if (defined($cli_verbose));
$err = dump_data($output_file, $comparison->{left});
exit_error(sprintf('cannot create the file "%s": %s', $output_file, $err)) if (defined($err));

$output_file = sprintf('%s-only-right', $cli_prefix);
printf("%-25s: %s\n", 'only right', $output_file) if (defined($cli_verbose));
$err = dump_data($output_file, $comparison->{right});
exit_error(sprintf('cannot create the file "%s": %s', $output_file, $err)) if (defined($err));

exit(0);

# Load the file identified by its path.
# Return the content of the file as an indexed data structure.
# @param $inPath the path of the file to load.
# @return the function returns 2 values:
#         - a reference to a hash that contains the loaded lines.
#           key: one line of the file.
#           value: the number of times the key has been encountered.
#         - an optional error message.
#         If the first value is `undef`, then it means that an error occurred.

sub slurp {
    my ($inPath) = @_;
    my $fd = undef;
    my %data = ();

    unless (open($fd, '<', $inPath)) { return(undef, $!) }
    while (my $line = <$fd>) {
        chomp($line);
        $data{$line} = 0 unless (exists($data{$line}));
        $data{$line} += 1;
    }
    close($fd);
    return(\%data, undef)
}

# Dump the result of a comparison into a file.
# @param $inPath the path to the output file.
# @param $inContent the reference to a hash that represents the result to dump.
# @return upon successful completion, the function returns the value `undef`.
#         Otherwise, the function returns a string that represents an error message.

sub dump_data {
    my ($inPath, $inContent) = @_;
    my $fd = undef;
    my $m = undef;

    $m = get_max($inContent);
    unless (open($fd, '>', $inPath)) { return $! }
    foreach my $key (sort keys %{$inContent}) {
        printf($fd "%-${m}s %d\n", $key, $inContent->{$key});
    }
    close($fd);
    return undef;
}

# Calculate the intersection between two sets of data.
# @param $inContent1 the first set of data. This is a reference to a hash.
# @param $inContent2 the second set of data. This is a reference to a hash.
# @return a reference to a hash that represents the intersection.

sub intersection {
    my ($inContent1, $inContent2) = @_;
    my %result = ();

    foreach my $key (keys %{$inContent1}) {
        next unless (exists($inContent2->{$key}));
        $result{$key} = $inContent1->{$key} + $inContent2->{$key};
    }
    return(\%result)
}

# Calculate the difference between two sets of data.
# @param $inContent1 the first set of data. This is a reference to a hash.
# @param $inContent2 the second set of data. This is a reference to a hash.
# @return a reference to a hash that represents the difference.

sub difference {
    my ($inContent1, $inContent2) = @_;
    my %result = (left => {}, right => {});

    foreach my $key (keys %{$inContent1}) {
        next if (exists($inContent2->{$key}));
        $result{left}->{$key} = $inContent1->{$key};
    }

    foreach my $key (keys %{$inContent2}) {
        next if (exists($inContent1->{$key}));
        $result{right}->{$key} = $inContent2->{$key};
    }

    return(\%result)
}

# Compare two sets of data: calculate the intersection and the difference.
# @param $inContent1 the first set of data. This is a reference to a hash.
# @param $inContent2 the second set of data. This is a reference to a hash.
# @return a reference to a hash that represents the result of the comparison.

sub compare {
    my ($inContent1, $inContent2) = @_;
    my $difference = difference($inContent1, $inContent2);

    return {
        both  => intersection($inContent1, $inContent2),
        left  => $difference->{left},
        right => $difference->{right}
    }
}

# Key the length of the longest key within a hash.
# @param $inHash the reference to the hash.
# @return the length of the longest key.

sub get_max {
    my ($inHash) = @_;
    my $maximum = 0;

    foreach my $key (keys %{$inHash}) {
        $maximum = length($key) if (length($key) > $maximum);
    }
    return($maximum);
}

sub exit_error {
    my ($in_message) = @_;
    printf(STDERR "FATAL: %s\n", $in_message);
    exit(1);
}

sub help {
    print("Usage:\n\n");
    printf("perl diff.pl [--verbose] [--prefix=<prefix>] <left file> <right file>\n\n");
    printf("Default prefix: \"%s\"\n\n", &DEFAULT_PREFIX);
    print("Generate:\n\n");
    print("* <prefix>-both:       lines found in both files\n");
    print("* <prefix>-only-left:  lines found in in the left file only\n");
    print("* <prefix>-only-right: lines found in in the right file only\n");
}
```

