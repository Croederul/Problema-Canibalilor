%sumDIgits(number) = { 0, number = 0,
%						{number % 10 + sumDigits(number div 10), number%10 este impar
%						{sumDIgits(number div 10), altfel

sumDigits(0,0). % fact, fapta
sumDigits(Number,Sum):- %Rule sau Regula (a doua ramura din model matem)
    Number =\= 0,
    Digit is Number mod 10,
    Digit mod 2 =:= 1,
    NumberNew is Number div 10,
    sumDigits(NumberNew,SumNew),
    Sum is SumNew + Digit.
sumDigits(Number,Sum):-
    Number =\= 0,
    Digit is Number mod 10,
    Digit mod 2 =:=0,
    NumberNew is Number div 10,
    sumDigits(NumberNew,SumNew),
    Sum is SumNew.


    