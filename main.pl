#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw/shuffle/;

# list of all faces
my @ranks = (('A'), (2..10), ('J','Q','K'));
# list of all suits
my @suits = qw/♠ ♥ ♦ ♣/;

# Array containing the cards won by each player
my @players_cards = ();
$players_cards[0] = [];
$players_cards[1] = [];

# Building a standard pack
my @standard_pack = ();
my $i=0; my $j=0;
for ($i=0; $i<@ranks; $i++) {
  for ($j=0; $j<@suits; $j++) {
    push(@standard_pack, "$ranks[$i]$suits[$j]")
  }
}

my %matching_conditions = (
  'F'=>'Face value',
  'S'=>'Suit',
  'B'=>'Both'
);

# Reading the number of packs from the input line
my $N="";
while ($N !~ /^\d+$/) {
  print "Get me the number of packs you want to use ";
  print "(Note: Every pack is composed by 4 suit; every suit has 13 standard card):";
  $N = <STDIN>;
  chomp $N;
}
print "Packs count Choosen: $N\n\n";

# Reading the matching condition from the input line
my $MC="";
while ($MC !~ /^(F|S|B)+$/) {
  print "Get me a matching condition between the following ones: \n";
  for(keys %matching_conditions){
   print("$_ => $matching_conditions{$_}\n");
  }

  $MC = <STDIN>;
  chomp $MC;
}
print "Choosen matching condition: $matching_conditions{$MC}\n\n";

# Building the full packs set
my @all_packs = ();
for ($i=0; $i<$N; $i++) {
  @all_packs = (@all_packs, @standard_pack);
}

# shuffle all cards
@all_packs = shuffle @all_packs;

my $previous_card="";
my $current_card="";

# Array containing the card extracted and not yet assigned
my @unassigned_cards=();

while ($current_card = pop(@all_packs)) {
  my $comparison_success = 0;

  if  ((
        ($MC eq "S") &&
        ((substr $current_card, 1) eq (substr $previous_card, 1))
        # Suit comparison
      )
      ||
      (
        ($MC eq "F") &&
        ((substr $current_card, 0, 1) eq (substr $previous_card, 0,1))
        # Face comparison
      )
      ||
      (
        ($MC eq "B") &&
        ($current_card eq $previous_card)
        # Both comparison
      )
      )
  {
        # The comparison has been successful
      my $choosenPlayer = int(rand(2));
      push(@unassigned_cards, $current_card); # Assigning the current card to the unassgned list
      while (my $item = pop(@unassigned_cards)) {
        # Trasferring all cards from unassigned_cards to the players_cards of choosen player
        push(@{$players_cards[$choosenPlayer]},$item);
      }
      $current_card=""; # Cleaning the current card
  }
  else {
    push(@unassigned_cards, $current_card); # Assigning the current card to the unassgned list
  }
  $previous_card=$current_card; # The last played card becomes the current one
}

# Printing results
print "---------  R E S U L T S -----------\n";
print "Player 1 cards #: " . (0+@{$players_cards[0]}) . "\n";
print "Player 2 cards #: " . (0+@{$players_cards[1]}) . "\n";
print "Unassigned cards: " . (0+@unassigned_cards) . "\n";

print "And the winner " .
      ( (0+@{$players_cards[0]}) == (0+@{$players_cards[1]}) ? "are Player 1 and Player 2 with the same points!" :
        ((0+@{$players_cards[0]}) > (0+@{$players_cards[1]}) ? "is Player 1!" : "is Player 2!")) .
      "\n";
