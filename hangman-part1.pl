use strict;
use warnings;

my @words = ('perl', 'programming', 'language', 'hangman', 'game');
my $word = $words[int(rand(@words))];
my $secretWord = '_' x length($word);
my $attempts = 6;
my @guessedLetters;

#   o
#  /|\
#  / \
sub printHangman {
    my ($wrongGuesses) = @_;

    my $hangman;

    # Initially, only print the hang post
    $hangman =  "   +---+\n";
    $hangman .= "       |\n";
    $hangman .= "       |\n";
    $hangman .= "       |\n";
    $hangman .= "      ===\n";

    if ($wrongGuesses == 1) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "       |\n";
        $hangman .= "       |\n";
        $hangman .= "      ===\n";
    } elsif ($wrongGuesses == 2) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "   |   |\n";
        $hangman .= "       |\n";
        $hangman .= "      ===\n";
    } elsif ($wrongGuesses == 3) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "   |\\  |\n"; # zbog escaping \, imamo ovu izbocinu
        $hangman .= "       |\n";
        $hangman .= "      ===\n";
    } elsif ($wrongGuesses == 4) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "  /|\\  |\n";
        $hangman .= "       |\n";
        $hangman .= "      ===\n";
    } elsif ($wrongGuesses == 5) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "  /|\\  |\n";
        $hangman .= "    \\  |\n";
        $hangman .= "      ===\n";
    } elsif ($wrongGuesses >= 6) {
        $hangman =  "   +---+\n";
        $hangman .= "   O   |\n";
        $hangman .= "  /|\\  |\n";
        $hangman .= "  / \\  |\n";
        $hangman .= "      ===\n";
    }
    print "\n";
    print $hangman;
    print "\n";
}

print "\n";
print "~~~ Welcome to Hangman! ~~~\n";
printHangman(0);
print "Guess the word: $secretWord\n";

while ($attempts > 0) {
    print "\n";
    # print "Attempts left: $attempts\n";
    # print "Guessed letters: @guessedLetters\n";
    print "Enter a letter: ";
    my $guess = <STDIN>;
    # Remove the trailing \n character from the input
    chomp($guess);

    # Check if we already guessed the letter
    my $alreadyGuessedFlag = 0;
    foreach my $letter (@guessedLetters) {
        if ($letter eq $guess) {
            # Set the flag
            $alreadyGuessedFlag = 1;
            last;
        }
    }

    if ($alreadyGuessedFlag) {
        print "You already guessed '$guess'. Try again.\n";
        next;
    } 
    # =~ operator since we are expecting a regex and matching the pattern
    if (!($guess =~ /^[a-zA-Z]$/ && length($guess) == 1)) {
        print "Invalid input. Please enter only a single letter. It's not that hard...\n";
        next;
    }
    # Add our guess to the guessed letters array
    push(@guessedLetters, $guess);

    # If index of the guessed letter is -1, it isn't the word => wrong guess
    if (index($word, $guess) == -1) {
        $attempts--;
        print "Wrong guess! $secretWord\n";
        printHangman(6 - $attempts);
        print "Attempts left: $attempts\n";
        print "Guessed letters: @guessedLetters\n";
        print "___________________\n";
        next;
    }
    
    # Loop trough the secret word
    for my $i (0 .. length($word) - 1) {
        # For every correctly guessed letter in the word, replace "_" with the correct letter in the secretWord
        if (substr($word, $i, 1) eq $guess) {
            # Replace the "_" with the letter that we guessed correctly
            substr($secretWord, $i, 1) = $guess;
        }
    }
    print "Good guess! $secretWord\n";

    last if $secretWord eq $word;
}

if ($secretWord eq $word) {
    print "Woohoo! You guessed the word: $word\n";
} else {
    print "Sorry, you ran out of attempts :( The word was: $word\n";
}
