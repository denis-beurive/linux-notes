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
MIIF6AYJKoZIhvcNAQcDoIIF2TCCBdUCAQAxggUeMIIFGgIBADCBpzCBmTELMAkG
A1UEBhMCSUwxEDAOBgNVBAgTB0NlbnRyYWwxEDAOBgNVBAcTB1JhYW5hbmExDzAN
BgNVBAoTBmFtZG9jczEMMAoGA1UECxMDV01UMSUwIwYDVQQDExxtYWNyZXBvcnRp
bmcuY29ycC5hbWRvY3MuY29tMSAwHgYJKoZIhvcNAQkBFhF3bXRhbGxAYW1kb2Nz
LmNvbQIJAPKpzLFUszFYMA0GCSqGSIb3DQEBAQUABIIEWk/ImeSYH1yGgK9wscxS
RZlqt9UurQY3wH9ZSlQEv0WyGJndmveYfEtKfOoem99TCyqopYDFfWcqGwnv57eS
fP4XHTVw4AD14zznq4gfPJjLhtXBTcjFtkgqQLsN/fOUTV2ic+nAjnAa7Okw7kd0
lXwwBtpdcD9EvMvteN1DYsLLvon6qQ3Ba1r2PYGgvmezz8WG6AAmz8h3yGtXeAqH
+e0z2aT/Ob9lpGJuvGqJUXjkcvJrVuuWPplubR5I1FJfpD+sECgw/w+swt30VLcf
Spaysm2DiiYXdyu8k/fWVhiNjNCD8D1yTJR5wvBVOFNiQs++DtagFxb8Z+Njp/hv
lBWCN+F9twPzlH16bg/6PWXLbSNMk61ixWdjWMqtaeI3hRIqRla5uQL131yIGXzy
PN4XIyMQnwMSSvsQR2IMKEN6WAdGn4+v5U2IQAjbBRPiruMf+q0BVKu97rxXGffg
2MaB3PjwofBknY+SO9m9Nfyf1M+90h10lIyv7l3QrQjwaC8+gjSNvA9HqgjjrI6/
KZP7xePww8e+2ozhxFtU5Yex0vjbPGwEFPtur1hcsJIFWcCIgvGty+Aaf3n1E4F1
2+4y4v3fZO9Aku3j4+mL+n8dkNUVQw8IYXtd03lhbWlQlXOKqUqZ3HEwTaHuN8NR
7RlBhbKP85eN3GVzdVNqkv8OWYtVFG0pkTlU7QNirOEE+LmCX9PpbUVL0WM75kXK
xw2AeUOkm1Wrl3ew514ObPw2pgYvgyIayQMFkg8sO9lfCwjRu6NdkszjytvszDBJ
RpcVDAf38pMTGwDXRE7CxrEp5aqAm9wHSTFZIdqBnJ+/1uGxoVT1jk4LiCz0c0Vg
24/MMaFWGfpD5HFJjZuG6wTs2Nis0aDNnnK90eM4z893e8ojx/XDRayjWk9HEEAH
m7wephJ0M8sOhkaW6yqfjF9J9kKzXUeJKoAu+bnvb4EKm7pcCAWCbmxbYvMnRmnk
pC3+mCPhPbVc0ByJ3DMGyrBQQbGQfIp2odXr0uQ5udkggJfjv5Qwm+wWxPSL0HMA
maB52x4Lzeb5BwL9zHtaLuZJwnM+mHKX7wfOCzUY+3fqdwpZ2sIA8ND2vFyzHQvh
rlzrGhIDqwt7kmn+Weh8/NnPrFEEZFZTGtDmn2TB4FrIRq8aP3HkwW8/3Lt52v/d
72ty8sypuxyzxezi9Ny8dftn5WouaPO2Dm/Yc0rp7QHSGQGHqUDAwPiIIFCYUKlF
ZLQ1zpM8W2KFZyc6fIPXZNT9VffBYUV8TV6qzn98yZtsA/ILpqAJXa331iBIqf9M
Fb9wbcxW0zzLFlVOW7tVgCniJPD90X0bOgQKsPZMlV4dfETpqfkcpEAn3p644M3F
fuyKhymL5s2KgVUfV9lxqWQfCX2E9P3vUS4ivsxPH7HEgAX80pLxpYJH54PikV+Q
ELufvjNh6P1qVG2c6bYOqqiQegxeMGM4H/E2WWWUwWqKbXZmZmb2IV8G5yIwga0G
CSqGSIb3DQEHATAdBglghkgBZQMEASoEEMOMNOkZhYGNzlaXPYtkwuuAgYAZywPG
zMizOuIhL875mrW6gjzf5nKR1EsnFoRKQ6X/9/k348YHld714JpzA2vpW7UNtvir
MYnoiSPSzQ8CbYJXrAoMMB6sfMG1fJe+wUVjef2cqSZ2oiuYvTtpmXsuQGOtvWlj
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
