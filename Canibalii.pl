% stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, PozitieBarca) :-
    verifica_mal(Misionari, Canibali) :- Misionari = 0.
    verifica_mal(Misionari, Canibali) :- Misionari >= Canibali.
    in_siguranta(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, PozitieBarca)) :- 
        verifica_mal(MisionariStg, CanibaliStg),
        verifica_mal(MisionariDr, CanibaliDr).

    % barca(Canibali, Misionari)
    barca(1, 0),
    barca(2, 0),
    barca(0, 1),
    barca(0, 2),
    barca(1, 1).

    traversare(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, stg), stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, dr)) :-
        barca(CanibaliBarca, MisionariBarca),
        CanibaliStg >= CanibaliBarca,
        MisionariStg >= MisionariBarca,
        CanibaliStgNou is CanibaliStg - CanibaliBarca,
        CanibaliDrNou is CanibaliDr + CanibaliBarca,
        MisionariStgNou is MisionariStg - MisionariBarca,
        MisionariDrNou is MisionariDr + MisionariBarca,
        in_siguranta(stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, dr)).

    traversare(stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, dr), stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, stg)) :-
        barca(CanibaliBarca, MisionariBarca),
        CanibaliDr >= CanibaliBarca,
        MisionariDr >= MisionariBarca,
        CanibaliStgNou is CanibaliStg + CanibaliBarca,
        CanibaliDrNou is CanibaliDr - CanibaliBarca,
        MisionariStgNou is MisionariStg + MisionariBarca,
        MisionariDrNou is MisionariDr - MisionariBarca,
        in_siguranta(stare(CanibaliStgNou, CanibaliDrNou, MisionariStgNou, MisionariDrNou, stg)).