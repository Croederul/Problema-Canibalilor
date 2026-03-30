% stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, PozitieBarca)
% Verificarea sigurantei malurilor
verifica_mal(Misionari, Canibali) :- Misionari = 0.
verifica_mal(Misionari, Canibali) :- Misionari >= Canibali.
in_siguranta(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, PozitieBarca)) :- 
        verifica_mal(MisionariStg, CanibaliStg),
        verifica_mal(MisionariDr, CanibaliDr).

% barca(Canibali, Misionari) - combinatiile posibile de pasageri.
barca(1, 0).
barca(2, 0).
barca(0, 1).
barca(0, 2).
barca(1, 1).

% Defineste mutarea persoanelor de la stanga la dreapta - scade pasagerii din stanga si ii adauga in dreapta.
traversare(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, stg), stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, dr)) :-
        barca(CanibaliBarca, MisionariBarca),
        CanibaliStg >= CanibaliBarca,
        MisionariStg >= MisionariBarca,
        CanibaliStgNou is CanibaliStg - CanibaliBarca,
        CanibaliDrNou is CanibaliDr + CanibaliBarca,
        MisionariStgNou is MisionariStg - MisionariBarca,
        MisionariDrNou is MisionariDr + MisionariBarca,
        in_siguranta(stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, dr)).

% Defineste mutarea persoanelor de la dreapta la stanga - scade pasagerii din dreapta si ii adauga in stanga.
traversare(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, dr), stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, stg)) :-
        barca(CanibaliBarca, MisionariBarca),
        CanibaliDr >= CanibaliBarca,
        MisionariDr >= MisionariBarca,
        CanibaliStgNou is CanibaliStg + CanibaliBarca,
        CanibaliDrNou is CanibaliDr - CanibaliBarca,
        MisionariStgNou is MisionariStg + MisionariBarca,
        MisionariDrNou is MisionariDr - MisionariBarca,
        in_siguranta(stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, stg)).

% Logica de cautare (DFS)
% Cazul de baza: am ajuns la starea finala
dfs(stare(0, 3, 0, 3, dr), _, Cale, Cale).

% Pasul recursiv
dfs(StareCurenta, Vizitate, CaleAcumulata, CaleFinala) :-
    traversare(StareCurenta, StareNoua),
    \+ member(StareNoua, Vizitate),
    dfs(StareNoua, [StareNoua|Vizitate], [StareNoua|CaleAcumulata], CaleFinala).

% Rezolvare si afisare solutie

rezolva :-
    Initiala = stare(3, 0, 3, 0, stg),
    % Cautam solutia incepand cu starea initiala in lista de vizitate
    (dfs(Initiala, [Initiala], [Initiala], DrumInversat) ->
        reverse(DrumInversat, Drum),
        afiseaza_solutie(Drum)
    ;   write('Nu a fost gasita nicio solutie.')).

afiseaza_solutie([]).
afiseaza_solutie([stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, Barca)|Rest]) :-
    format('Mal Stanga: ~dC, ~dM | Barca: ~w | Mal Dreapta: ~dC, ~dM~n', [CanibaliStg, MisionariStg, Barca, CanibaliDr, MisionariDr]),
    afiseaza_solutie(Rest).