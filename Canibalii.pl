% ==========================================================
% 1. DEFINIREA STARII SI A REGULILOR DE SIGURANTA
% ==========================================================
% O stare este definita ca: 
% stare(CanibaliStg, CanibaliDr, MisionariStg, MisionariDr, PozitieBarca)

% --- Verificarea sigurantei malurilor ---
% Un mal este sigur daca nu sunt misionari (M=0) 
% SAU daca misionarii sunt cel putin la fel de multi ca canibalii (M >= C).

% Regula scrisa de coleg:
verifica_mal(Misionari, _) :- 
    Misionari =:= 0.
verifica_mal(Misionari, Canibali) :- 
    Misionari > 0, 
    Misionari >= Canibali.

% Regula de siguranta generala:
in_siguranta(stare(CS, CD, MS, MD, _)) :- 
    verifica_mal(MS, CS), % Verificam malul stang
    verifica_mal(MD, CD). % Verificam malul drept

% --- Capacitatea barcii ---
% barca(Canibali, Misionari) - max 2 persoane total, minim 1.
barca(1, 0). % 1 Canibal
barca(2, 0). % 2 Canibali
barca(0, 1). % 1 Misionar
barca(0, 2). % 2 Misionari
barca(1, 1). % 1 de fiecare

% ==========================================================
% 2. DEFINIREA MUTARILOR (TRAVERSAREA)
% ==========================================================

% --- Traversare de la STÂNGA la DREAPTA ---
% Scadem pasagerii din stanga si ii adaugam in dreapta.
traversare(stare(CS, CD, MS, MD, stg), stare(CSN, CDN, MSN, MDN, dr)) :-
    barca(CB, MB),
    CS >= CB, 
    MS >= MB,
    CSN is CS - CB, 
    CDN is CD + CB,
    MSN is MS - MB, 
    MDN is MD + MB,
    in_siguranta(stare(CSN, CDN, MSN, MDN, dr)).

% --- Traversare de la DREAPTA la STÂNGA ---
% Scadem pasagerii din dreapta si ii adaugam in stanga.
traversare(stare(CS, CD, MS, MD, dr), stare(CSN, CDN, MSN, MDN, stg)) :-
    barca(CB, MB),
    CD >= CB, 
    MD >= MB,
    CSN is CS + CB, 
    CDN is CD - CB,
    MSN is MS + MB, 
    MDN is MD - MB,
    in_siguranta(stare(CSN, CDN, MSN, MDN, stg)).

% ==========================================================
% 3. LOGICA DE CAUTARE (DFS)
% ==========================================================

% DFS - Cazul de bază: Am ajuns la starea finală (toți pe malul drept)
dfs(stare(0, 3, 0, 3, dr), stare(0, 3, 0, 3, dr), Cale, Cale).

% DFS - Pasul recursiv:
dfs(StareCurenta, StareFinala, Vizitate, Cale) :-
    traversare(StareCurenta, StareNext),
    \+ member(StareNext, Vizitate), % Previne buclele infinite
    dfs(StareNext, StareFinala, [StareNext|Vizitate], Cale).

% ==========================================================
% 4. REZOLVITORUL SI AFISAREA
% ==========================================================

rezolva(Cale) :-
    StareInitiala = stare(3, 0, 3, 0, stg),
    StareFinala   = stare(0, 3, 0, 3, dr),
    % Incepem cautarea
    dfs(StareInitiala, StareFinala, [StareInitiala], CaleInversa),
    % Inversam lista pentru a vedea pasii in ordine cronologica
    reverse(CaleInversa, Cale).

print_solutie :-
    (rezolva(Cale) ->
        format('~n--- SOLUTIE GASITA (Pas cu Pas) ---~n', []),
        afiseaza_pasi(Cale)
    ;   write('Nu exista solutie.')
    ).

% Predicat recursiv pentru afisare formatata
afiseaza_pasi([]).
afiseaza_pasi([stare(CS, CD, MS, MD, Barca)|Rest]) :-
    format('Stanga: [C:~d, M:~d] | Barca: ~w | Dreapta: [C:~d, M:~d]~n', 
           [CS, MS, Barca, CD, MD]),
    afiseaza_pasi(Rest).

% ==========================================================
% 5. EXTRA: SUMA CIFRELOR IMPARE
% ==========================================================
sumDigits(0, 0).
sumDigits(N, S) :-
    N > 0, 
    D is N mod 10, 
    D mod 2 =:= 1, !,
    Next is N div 10, 
    sumDigits(Next, SP), 
    S is SP + D.
sumDigits(N, S) :-
    N > 0, 
    Next is N div 10, 
    sumDigits(Next, S).