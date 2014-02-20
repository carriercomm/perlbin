#!/usr/bin/perl
$sitename = "http://0x80.co.uk/pastes/";    
$pastedir = "/var/www/pastes";              

my ( $buffer, @pairs, $pair, $name, $value, %FORM );

#read text from form
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ( $ENV{'REQUEST_METHOD'} eq "POST" ) {
    read( STDIN, $buffer, $ENV{'CONTENT_LENGTH'} );
}
else {
    $buffer = $ENV{'QUERY_STRING'};
}

#process POST
@pairs = split( /&/, $buffer );
foreach $pair (@pairs) {
    ( $name, $value ) = split( /=/, $pair );
    $value =~ tr/+/ /;
    $value =~ s/%(..)/pack("C", hex($1))/eg;
    $FORM{$name} = $value;
}

$paste      = $FORM{paste};

@chars = ( "A" .. "Z", "a" .. "z", 0 .. 9, qw(-_) );
$filename = join( "", @chars[ map { rand @chars } ( 1 .. 4 ) ] );
$filename = $filename . ".html";

unless ( open FILE, ">$pastedir/$filename" ) {
    die "\nError, could not create the paste\n";
}

$html = "
<!doctype html>
<html>
<head>
<meta charset='utf-8'>
<title>$filename</title>
</head>
<body>
$paste
</body>
</html>";

print FILE $html;
close FILE;

$pastelink = $sitename . $filename;
print "Location: $pastelink\n\n;";

