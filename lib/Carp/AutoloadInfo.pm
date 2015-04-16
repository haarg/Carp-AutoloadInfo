package Carp::AutoloadInfo;
use strict;
use warnings;

sub _caller(;$) {
  my ($height) = @_;
  $height++;
  my @caller;
  if (CORE::caller() eq 'DB') {
    package DB;
    @caller = CORE::caller($height);
  }
  else {
    @caller = CORE::caller($height);
  }
  if (@caller && $caller[3] =~ /::AUTOLOAD$/ && (CORE::caller(1))[3] =~ /^Carp::[^:]+$/) {
    my $sub = $caller[3];
    my $autoload = do { no strict 'refs'; ${$sub} };
    if ($autoload) {
      $autoload =~ s/.*:://;
      $caller[3] .= "[$autoload]";
    }
  }
  return if ! @caller;
  return $caller[0] if ! wantarray;
  return @_ ? @caller : @caller[0..2];
}

sub import {
  *CORE::GLOBAL::caller = \&_caller;
}
sub unimport {
  delete ${CORE::GLOBAL::}{caller};
}

1;
