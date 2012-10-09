var cluster = require('cluster');

if( cluster.isMaster ) {
  for( var i = 0; i < 4; i ++ ) {
    cluster.fork();
  }
}
else {
  var http = require('http');
  http.createServer( function( req, res ) {
    res.writeHead( 200, { 'Content-Type': 'text/plain' } );
    res.write( 'Hello World !' );
    res.end();
  } ).listen( 3000 );
}
