use strict;
use warnings;
use Test::More;
use Carp;
use Carp::AutoloadInfo;

BEGIN {
  package ClassA;

  sub AUTOLOAD {
    (my $method = our $AUTOLOAD) =~ s/.*:://;
    my $class = shift;
    $method = "auto_$method";
    $class->$method(@_);
  }

  sub auto_foo {
    warn Carp::longmess();
  }
}

ClassA->foo;

