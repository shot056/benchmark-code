#!/usr/bin/env perl

use strict;
use warnings;

my $app = sub {
    my $env = shift;
    return [
        200,
        [ 'Content-Type' => 'text/plain' ],
        [ "Hello World" ],
        ];
};

return  $app;
