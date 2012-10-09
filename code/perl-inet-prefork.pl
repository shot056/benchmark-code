use IO::Socket::INET;
use Parallel::Prefork;

sub MaxRequestsPerChild () { 100 }

my $listen_sock = IO::Socket::INET->new(
    Listen    => 10,
    LocalAddr => '0.0.0.0:5000',
    Proto     => 'tcp',
) or die $!;

my $pm = Parallel::Prefork->new({
    max_workers  => 10,                           # ワーカープロセスの個数
#    trap_signals => {
#        TERM => 'TERM',                           # SIGTERM を受信したらワーカープロセスを SIGTERM
#        HUP  => 'TERM',                           # SIGHUP の場合も同様
#    }
});

# メインループ
while ($pm->signal_received ne 'TERM') {
    $pm->start and next;                          # ワーカープロセス生成処理

    while(my $c = $listen_sock->accept){
      my $q = $c->getline;
      $c->print( "HTTP/1.0 200 OK\r\n");
      $c->print( "Content-Type: text/plain\r\n" );
      $c->print( "Content-Length: 13\r\n" );
      $c->print( "\r\n" );
      $c->print( "Hello World !" );
      $c->close;
    }
#    my $reqs_before_exit = MaxRequestsPerChild;   # ここからワーカープロセス内
#    $SIG{TERM} = sub { $reqs_before_exit = 0 };
#    while ($reqs_before_exit-- > 0) {
#        my $s = $listen_sock->accept();           # リクエストを処理
#
#        $s->print( "HTTP/1.0 200 OK\r\n");
#        $s->print( "Content-Type: text/plain\r\n" );
#        $s->print( "Content-Length: 13\r\n" );
#        $s->print( "\r\n" );
#        $s->print( "Hello World !" );
#        $s->close;
#    }
    $pm->finish;                                  # ワーカープロセスの終了処理
}

$pm->wait_all_children;                           # 子プロセスを待ち受け

#my $s = IO::Socket::INET->new(
#  LocalAddr => "192.168.10.19",
#  LocalPort => 5000,
#  Proto     => "tcp",
#  Listen    => 10,
#  ReuseAddr => 1
#) or die $!;
#
#$s->listen or die $!;
#
#while(my $c = $s->accept){
#  my $q = $c->getline;
#  $c->print( "HTTP/1.0 200 OK\r\n");
#  $c->print( "Content-Type: text/plain\r\n" );
#  $c->print( "Content-Length: 13\r\n" );
#  $c->print( "\r\n" );
#  $c->print( "Hello World !" );
#  $c->close;
#}

