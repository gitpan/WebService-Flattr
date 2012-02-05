#!perl

BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}


use strict;
use warnings;

# +1 for Test::NoWarnings
use Test::More tests => 19 + 1;
use Test::NoWarnings;
use WebService::Flattr ();

my $flattr = WebService::Flattr->new();

{
    # This will fail if the "flattr" user does not have any publicly
    # viewable flattrs.
    my $result = $flattr->user_flattrs({
        username => 'flattr',
    })->data;
    isa_ok $result, 'ARRAY', 'Expected result structure';
    is $result->[0]{type}, 'flattr', 'Expected result type';
    isa_ok $result->[0]{thing}, 'HASH', 'Expected result thing structure';
}

{
    # This will fail if the user "flattr" owns less than 3 things
    my $result = $flattr->things_owned_by({
        username => 'flattr',
        count => 3,
    })->data;
    isa_ok $result, 'ARRAY', 'Expected result structure';
    is @$result, 3, 'Expected number of results';
    is $result->[0]{type}, 'thing', 'Expected result type';
    is $result->[0]{owner}{username}, 'flattr', 'Expected username';
}

{
    # This will fail if the thing with ID 123 goes away
    my $result = $flattr->get_thing(123)->data;
    isa_ok $result, 'HASH', 'Expected result structure';
    is $result->{type}, 'thing', 'Expected result type';
    is $result->{id}, 123, 'Expected ID';
}

{
    # This will fail if the requested things leave Flattr's directory
    my $result = $flattr->get_things(10, 101, 1002)->data;
    isa_ok $result, 'ARRAY', 'Expected result structure';
    is @$result, 3, 'Expected number of results';
    is $result->[0]{type}, 'thing', 'Expected first result type';
    is $result->[0]{id}, 10, 'Expected first result ID';
    is $result->[1]{id}, 101, 'Expected second result ID';
    is $result->[2]{id}, 1002, 'Expected third result ID';
}

{
    # This will fail if the requested URL leaves Flattr's directory
    my $result = $flattr->thing_exists('http://www.cyanogenmod.com/')
        ->data;
    isa_ok $result, 'HASH', 'Expected result structure';
    is $result->{message}, 'found', 'Expected result message';
    like $result->{location}, qr/^http/, 'Expected location type';
}

# TODO:
# - search_things
# - user
# - user_activities
# - categories
# - languages
