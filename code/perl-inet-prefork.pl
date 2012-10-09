use IO::Socket::INET;
use Parallel::Prefork;

sub MaxRequestsPerChild () { 100 }

my $listen_sock = IO::Socket::INET->new(
    Listen    => 10,
    LocalAddr => '0.0.0.0:5000',
    Proto     => 'tcp',
) or die $!;

my $pm = Parallel::Prefork->new({
    max_workers  => 10,
});

# メインループ
while ($pm->signal_received ne 'TERM') {
    $pm->start and next;

    while(my $c = $listen_sock->accept){
      my $q = $c->getline;
      $c->print( "HTTP/1.0 200 OK\r\n");
      $c->print( "Content-Type: text/plain\r\n" );
      $c->print( "Content-Length: 13\r\n" );
      $c->print( "\r\n" );
      $c->print( "Hello World !" );
      $c->close;
    }
    $pm->finish;
}

$pm->wait_all_children;
$listen_sock->listen or die $!;