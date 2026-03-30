# Problema Misionarilor și a Canibalilor

## Descriere
3 misionari și 3 canibali trebuie să traverseze un râu folosind o barcă de 2 persoane. 
Dacă pe oricare mal numărul canibalilor îl depășește pe cel al misionarilor, aceștia vor fi mâncați.

## Soluție
Implementarea folosește un algoritm de căutare în adâncime (DFS). 
Starile vizitate sunt stocate pentru a evita ciclurile infinite.

## Versiune Prolog
SWI-Prolog version 10.1.4-5-gdc353259c

## Exemple de rulare
Interogare: `?- rezolva.`
Output așteptat: O listă de stări care arată evoluția numărului de persoane de pe maluri până la starea (0,0) pe malul stâng.