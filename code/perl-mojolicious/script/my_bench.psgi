use Mojo::Server::PSGI;
use Plack::Builder;

my $psgi = Mojo::Server::PSGI->new( app_class => 'MyBench' );
my $app = sub { $psgi->run(@_) };

builder {
#    enable 'Session', store => 'File';
    $app;
};
