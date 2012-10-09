#!/usr/bin/perl

use strict;

use IO::Socket;


my $s = IO::Socket::INET->new(
  LocalAddr => "192.168.10.19",
  LocalPort => 5000,
  Proto     => "tcp",
  Listen    => 10,
  ReuseAddr => 1
) or die $!;

$s->listen or die $!;

while(my $c = $s->accept){
  my $q = $c->getline;
  $c->print( "HTTP/1.0 200 OK\r\n");
  $c->print( "Content-Type: text/plain\r\n" );
  $c->print( "Content-Length: 13\r\n" );
  $c->print( "\r\n" );
  $c->print( "Hello World !" );
  $c->close;
}

$s->close;
