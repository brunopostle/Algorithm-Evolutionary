#-*-cperl-*-

use Test::More;
use warnings;
use strict;

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

BEGIN { plan tests => 16;
    use_ok('Algorithm::Evolutionary::Individual::String');
};

#Object methods
my $indi = new Algorithm::Evolutionary::Individual::String ['a'..'z'], 10; # Build random bitstring with length 10
isa_ok( $indi, "Algorithm::Evolutionary::Individual::String" );
ok( $indi->{_length} == 10, 'Created with length' );
#Class methods
my @ops = $indi->my_operators;
is( $ops[0], 'Algorithm::Evolutionary::Op::Crossover', 'Allowed operators' ); 

my $indi3 = new Algorithm::Evolutionary::Individual::String;
$indi3->set( { length => 20, 
	       chars => ['A'..'Z'] } );   #Sets values, but does not build the string
$indi3->randomize(); #Creates a random bitstring with length as above

like( $indi3->Atom( 7 ), qr/^\w$/, 'Random creation');       #Returns the value of the 7th character
$indi3->Atom( 3, 'Q' );       #Sets the value
is( $indi3->Atom(3), 'Q', "Value setting" );

$indi3->addAtom( 'K' ); #Adds a new character to the bitstring at the end
is( $indi3->Atom(20), 'K', 'Adding stuff');
my $indi4 = Algorithm::Evolutionary::Individual::String->fromString( 'esto es un string');   #Creates an individual from that string

my $indi5 = $indi4->clone(); #Creates a copy of the individual
is_deeply($indi4,$indi5,'Cloning');

#Tie tests
my @array = qw( a x q W z �); #Tie a String individual
tie my @vector, 'Algorithm::Evolutionary::Individual::String', @array;
is( tied( @vector )->Atom(3), 'W', 'Tieing');

is( pop( @vector ), '�', 'Pop' );
is( shift( @vector), 'a', 'Shift' );
push( @vector, 'p' );
is( pop( @vector ), 'p', 'Push + pop' );
unshift( @vector, 'u' );
is( shift( @vector ), 'u', 'Unshift + shift' );
$vector[3] = 'k';
is( $vector[3], 'k', 'Store + fetch' );

my @mini_vector = splice( @vector, 2, 2 );
is( $mini_vector[1], 'k', 'Splice' );

#Testing XML stuff
  my $xml=<<EOC;
<indi type='String'>
    <atom>a</atom><atom>z</atom><atom>q</atom><atom>i</atom><atom>h</atom>
</indi>
EOC
$indi4=  Algorithm::Evolutionary::Individual::String->fromXML( $xml );
is( $indi4->Atom(4), 'h', 'from XML' );

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/07/24 11:55:45 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0101-string.t,v 1.2 2008/07/24 11:55:45 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.2 $
  $Name $

=cut