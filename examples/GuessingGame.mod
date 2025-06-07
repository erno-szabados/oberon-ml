MODULE GuessingGame;
(** A simple guessing game demonstrating the random module with a time seed. *)

IMPORT In, Out, Random, artClock;
CONST MaxTries = 10;
VAR
  guess, num, tries, seed: INTEGER;
  c : artClock.Clock;
BEGIN
  artClock.Update;
  artClock.Get(c);
  seed := c.year + c.month + c.day +
          c.hour + c.minute + c.second;
  Random.Init(seed);
  Out.String("Guessing Game"); Out.Ln;
  Out.String("Try to guess the number I'm thinking of (between 1 and 100). "); Out.Ln;
  Out.String("You have "); Out.Int(MaxTries, 0); Out.String(" tries."); Out.Ln;
  
  (* Initialize variables *)
  tries := 0;
  num := Random.Next() MOD 100 + 1; (* Generates a random integer between 1 and 100 *)
  WHILE tries < MaxTries DO
    Out.String("Enter guess: "); In.Int(guess);
    IF guess < num THEN
      Out.String("Too low!"); Out.Ln;
      INC(tries);
    ELSIF guess > num THEN
      Out.String("Too high!"); Out.Ln;
      INC(tries);
    ELSE
      Out.String("Congratulations! You guessed it in "); Out.Int(tries + 1, 0);
      Out.String(" tries."); Out.Ln;
      tries := MaxTries; (* Exit the loop *)
    END;
    IF (tries = MaxTries) & (guess # num) THEN
      Out.String("Sorry, you've used all your tries. The number was: ");
      Out.Int(num, 0); Out.Ln;
    END;

  END;
END GuessingGame.