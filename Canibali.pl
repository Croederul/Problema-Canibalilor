% --- Definirea barcii si a regulilor de siguranta ---

% barca(Canibali, Misionari) - combinatiile posibile de pasageri (max 2 persoane).
barca(1, 0).
barca(2, 0).
barca(0, 1).
barca(0, 2).
barca(1, 1).

% Verificarea sigurantei malurilor:
% Un mal este sigur daca nu sunt misionari (M=0) 
% SAU daca misionarii sunt cel putin la fel de multi ca canibalii (M >= C).
verifica_mal(0, _). % Daca nu-s misionari, canibalii n-au pe cine manca.
verifica_mal(M, C) :- M > 0, M >= C.

% Starea este sigura daca ambele maluri respecta regula.
in_siguranta(stare(CS, CD, MS, MD, _)) :- 
    verifica_mal(MS, CS),
    verifica_mal(MD, CD).

% --- Definirea mutarilor (Traversarea) ---

% Traversare de la stanga la dreapta.
traversare(stare(CS, CD, MS, MD, stg), stare(CSN, CDN, MSN, MDN, dr)) :-
    barca(CB, MB),
    CS >= CB, MS >= MB,
    CSN is CS - CB, CDN is CD + CB,
    MSN is MS - MB, MDN is MD + MB,
    in_siguranta(stare(CSN, CDN, MSN, MDN, dr)).

% Traversare de la dreapta la stanga.
traversare(stare(CS, CD, MS, MD, dr), stare(CSN, CDN, MSN, MDN, stg)) :-
    barca(CB, MB),
    CD >= CB, MD >= MB,
    CSN is CS + CB, CDN is CD - CB,
    MSN is MS + MB, MDN is MD - MB,
    in_siguranta(stare(CSN, CDN, MSN, MDN, stg)).

% --- Implementarea DFS cu lista de vizitate ---

% Predicatul principal pentru a gasi solutia.
rezolva(Cale) :-
    S_Start = stare(3, 0, 3, 0, stg),
    S_Final = stare(0, 3, 0, 3, dr),
    dfs(S_Start, S_Final, [S_Start], CaleInversa),
    reverse(CaleInversa, Cale).

% DFS: Cazul de baza (am ajuns la destinatie).
dfs(S_Final, S_Final, Vizitate, Vizitate).

% DFS: Pasul recursiv.
dfs(S_Curenta, S_Final, Vizitate, Cale) :-
    traversare(S_Curenta, S_Next),
    \+ member(S_Next, Vizitate), % Previne buclele infinite
    dfs(S_Next, S_Final, [S_Next|Vizitate], Cale).

% --- Afisarea rezultatelor ---

print_solutie :-
    (rezolva(Cale) ->
        format('~n--- Solutie Gasita (Misionarii si Canibalii) ---~n', []),
        afiseaza_pasi(Cale)
    ;   write('Nu a fost gasita nicio solutie.')
    ).

afiseaza_pasi([]).
afiseaza_pasi([stare(CS, CD, MS, MD, B)|T]) :-
    format('Stanga: [C:~d, M:~d] | Barca: ~w | Dreapta: [C:~d, M:~d]~n', [CS, MS, B, CD, MD]),
    afiseaza_pasi(T).

% 1. DFS - Logica de căutare cu prevenirea buclelor infinite
% ----------------------------------------------------------

% Cazul de bază: Destinația a fost atinsă
dfs(StareFinala, StareFinala, Cale, Cale).

% Pasul recursiv: Căutăm o stare nouă (Next) care NU se află în lista de Vizitate
dfs(StareCurenta, StareFinala, Vizitate, Cale) :-
    traversare(StareCurenta, StareNext),
    \+ member(StareNext, Vizitate), % Verifică să nu fi vizitat deja starea (previne loop-ul)
    dfs(StareNext, StareFinala, [StareNext|Vizitate], Cale).

% 2. Rezolvitorul - Definește Start/Final și inversează drumul găsit
% ----------------------------------------------------------
rezolva(Cale) :-
    StareInitiala = stare(3, 0, 3, 0, stg),
    StareFinala   = stare(0, 3, 0, 3, dr),
    % Incepem DFS cu starea initiala deja in lista de vizitate
    dfs(StareInitiala, StareFinala, [StareInitiala], CaleInversa),
    reverse(CaleInversa, Cale).

% 3. Afișarea - Transformă lista într-un format citibil
% ----------------------------------------------------------
print_solutie :-
    (rezolva(Cale) ->
        format('~n--- SOLUTIE GASITA (Pas cu Pas) ---~n', []),
        afiseaza_pasi(Cale)
    ;   write('Nu exista solutie.')).

afiseaza_pasi([]).
afiseaza_pasi([stare(CS, CD, MS, MD, Barca)|Rest]) :-
    format('Stanga: [C:~d, M:~d] | Barca: ~w | Dreapta: [C:~d, M:~d]~n', 
           [CS, MS, Barca, CD, MD]),
    afiseaza_pasi(Rest).

% 4. Extra: Suma Cifrelor Impare (în caz că trebuie trimisă și asta)
% ----------------------------------------------------------
sumDigits(0, 0).
sumDigits(N, S) :-
    N > 0, D is N mod 10, D mod 2 =:= 1, !,
    Next is N div 10, sumDigits(Next, SP), S is SP + D.
sumDigits(N, S) :-
    N > 0, Next is N div 10, sumDigits(Next, S).