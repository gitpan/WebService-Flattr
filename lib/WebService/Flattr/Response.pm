package WebService::Flattr::Response;
{
  $WebService::Flattr::Response::VERSION = '0.53';
}

use strict;
use warnings;

=head1 NAME

WebService::Flattr::Response - Handles responses from WebService::Flattr

=head1 VERSION

version 0.53

=head1 DESCRIPTION

This module provides objects describing responses from Flattr's social
micro-payments API generated by L<< WebService::Flattr >>.

=head1 METHODS

=cut

sub _new {
    my $class = shift;
    my $arg = shift;

    return bless $arg, $class;
}

=head2 data

This returns a data structure deserialised from the JSON part of the
response as defined by Flattr's API.

=cut

sub data {
    shift->{data};
}

=head2 http_response

This returns an L<< HTTP::Response >> object.

=cut

sub http_response {
    shift->{response};
}

=head2 rate_limit

This returns the number of rate limited requests per hour as defined by
the X-RateLimit-Limit header at L<<
http://developers.flattr.net/api/#rate-limiting >>.

=cut

sub rate_limit {
    shift->{response}->headers->header('X-RateLimit-Limit');
}

=head2 limit_remaining

This returns the number of rate limited requests remaining as defined by
the X-RateLimit-Remaining header at L<<
http://developers.flattr.net/api/#rate-limiting >>.

=cut

sub limit_remaining {
    shift->{response}->headers->header('X-RateLimit-Remaining');
}

1;
__END__
=head1 SEE ALSO

L<< WebService::Flattr >>

=head1 AUTHOR

Tom Hukins

=cut
