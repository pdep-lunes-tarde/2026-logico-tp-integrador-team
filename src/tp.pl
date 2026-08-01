

% ---------- Punto 1: la gente ----------

habitante(denken, 1290, humano, auberst).
habitante(voll, 1200, enano, ende).
habitante(serie, 500, elfo, weise).
habitante(fern, 1370, humano, weise).
habitante(stark, 1368, humano, riegel).
habitante(lawine, 1372, humano, auberst).
habitante(kanne, 1365, humano, weise).
habitante(wirbel, 1350, humano, klares).
habitante(lernen, 1315, humano, auberst).
habitante(frieren, 100, elfo, weise).
habitante(eisen, 1150, enano, riegel).

con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, elfo, _),
    Agno > Nacido.
con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, Raza, _),
    promedio_vida(Raza, Prom),
    Agno >= Nacido,
    Agno - Nacido =< Prom.

promedio_vida(humano, 80).
promedio_vida(enano, 350).


% ---------- Punto 2: los recuerdos ----------
% hazagna(nombre, participes, lugar)
% conoce(persona, ↑ hazagna ↑, forma_de_recordar, agno)
% eg: hazagna("Rescatar hermana Wirbel", [stark, fern], klares).

conoce(wirbel, hazagna("Rescatar hermana Wirbel", [stark, fern], klares), presenciar, 1390).
conoce(frieren, hazagna("Rescatar hermana Wirbel", [stark, fern], klares), presenciar, 1390).
conoce(lawine, hazagna("Destruir demonio Aura", [frieren], weise), escuchar, 1393).
conoce(voll, hazagna("Destruir demonio Aura", [denken], auberst), leer(50), 1400).
conoce(serie, hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende), leer(100), 1335).
conoce(kanne, hazagna("Recuperar gato perdido", [himmel, frieren], weise), presenciar, 1375).

conoce(Nombre, hazagna(Nombre_Hazagna, _, _), dia_festivo(Agno_Conmemora), Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, dia_festivo(Agno_Conmemora), hazagna(Nombre_Hazagna, _, _)),
    Agno_Conoce is max(Agno_Nacido, Agno_Conmemora),
    con_vida(Nombre, Agno_Conoce).

conoce(Nombre, hazagna(Nombre_Hazagna, _, _), estatua(Agno_Conmemora, Material, _, Mantenimiento), Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, estatua(Agno_Conmemora, Material, _, Mantenimiento), hazagna(Nombre_Hazagna, _, _)),
    Agno_Conoce is max(Agno_Nacido, Agno_Conmemora),
    con_vida(Nombre, Agno_Conoce).

recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), presenciar, Agno_Conoce),
    Agno_Conoce =< Agno. % ya verificamos que esté con vida
    
recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), escuchar, Agno_Conoce),
    Agno_Conoce =< Agno, Agno =< Agno_Conoce + 15.
    
recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), leer(Pags), Agno_Conoce),
    Agno_Conoce =< Agno, Agno =< Agno_Conoce + Pags.

recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), dia_festivo(_), Agno_Conoce),
    Agno_Conoce =< Agno.
recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), estatua(Agno_Construida, Material, _, Mantenimiento), Agno_Conoce),
    buen_estado(estatua(Agno_Construida, Material, _, Mantenimiento), Agno),
    Agno_Conoce =< Agno.

version_distinta(Nombre_Hazagna) :-
    conoce(N1, hazagna(Nombre_Hazagna, Part1, _), _, _),
    conoce(N2, hazagna(Nombre_Hazagna, Part2, _), _, _),
    N1 \= N2, Part1 \= Part2.
version_distinta(Nombre_Hazagna) :-
    conoce(N1, hazagna(Nombre_Hazagna, _, Lugar1), _, _),
    conoce(N2, hazagna(Nombre_Hazagna, _, Lugar2), _, _),
    N1 \= N2, Lugar1 \= Lugar2.

corroborada(Nombre_Hazagna) :-
    conoce(_, hazagna(Nombre_Hazagna, _, _), _, _),
    not(version_distinta(Nombre_Hazagna)).

olvidada_en(Nombre_Hazagna, Agno) :- 
    conoce(_, hazagna(Nombre_Hazagna, _, _), _, _),
    not(recuerda_en(Nombre_Hazagna, _, Agno)).


% ---------- Punto 3: conmemorando hazañas ----------

%conmemora(pueblo, forma (y su data + agno_inicio),
%   hazagna)
conmemora(weise, dia_festivo(1340), 
    hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende)).
conmemora(auberst, estatua(1370, bronce, "el equipo de heroes", [1400, 1450]),
    hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende)).
conmemora(auberst, estatua(1340, marmol, "el héroe del sur", [1410]),
    hazagna("Destruir Schlat Omnisciente", [heroe_del_sur], ende)).

buen_estado(estatua(Agno_Construida, bronce, _, _), Agno) :- Agno =< Agno_Construida + 15.
buen_estado(estatua(_, bronce, _, Mantenimiento), Agno) :- member(X, Mantenimiento), X=< Agno, Agno =< X + 15. % de guia de lenguajes
buen_estado(estatua(Agno_Construida, marmol, _, _), Agno) :- Agno =< Agno_Construida + 30.
buen_estado(estatua(_, marmol, _, Mantenimiento), Agno) :- member(X, Mantenimiento), X=< Agno, Agno =< X + 30.


% ---------- Tests ----------

:- begin_tests(tpIntegrador, []).
% --- Parte 1 ---
test("Kanne está viva en el 1370", nondet) :- con_vida(kanne, 1370).
test("Kanne NO está viva en el 1300", nondet) :- not(con_vida(kanne, 1300)).
test("Kanne NO está viva en el 2000", nondet) :- not(con_vida(kanne, 2000)).
test("Voll está vivo en el 1550", nondet) :- con_vida(voll, 1550).
test("Voll NO está viva en el 1551", nondet) :- not(con_vida(voll, 1551)).
test("Serie está viva en el 5000", nondet) :- con_vida(serie, 5000).

% --- Parte 2 ---
test("Lawine NO recuerda 'Destruir demonio Aura' en 1380", nondet) :- not(recuerda_en("Destruir demonio Aura", lawine, 1380)).
test("Lawine recuerda 'Destruir demonio Aura' en 1400", nondet) :- recuerda_en("Destruir demonio Aura", lawine, 1400).
test("Lawine NO recuerda 'Destruir demonio Aura' en 1410", nondet) :- not(recuerda_en("Destruir demonio Aura", lawine, 1415)).
test("Voll recuerda 'Destruir demonio Aura' en 1450", nondet) :- recuerda_en("Destruir demonio Aura", voll, 1450).
test("Voll NO recuerda 'Destruir demonio Aura' en 1460", nondet) :- not(recuerda_en("Destruir demonio Aura", voll, 1460)).
test("Wirbel recuerda 'Rescatar hermana Wirbel' en 1430", nondet) :- recuerda_en("Rescatar hermana Wirbel", wirbel, 1430).
test("Wirbel NO recuerda 'Rescatar hermana Wirbel' en 1440", nondet) :- not(recuerda_en("Rescatar hermana Wirbel", wirbel, 1440)).
test("'Rescatar hermana Wirbel' es una hazaña corroborada", nondet) :- corroborada("Rescatar hermana Wirbel").
test("'Destruir demonio Aura' pasó al olvido en 1460", nondet) :- olvidada_en("Destruir demonio Aura", 1460).
test("'Destruir demonio Aura' NO pasó al olvido en 1440", nondet) :- not(olvidada_en("Destruir demonio Aura", 1440)).

% --- Parte 3 ---
test("Lawine recuerda 'Destruir Rey Demonio' en 1400", nondet) :- recuerda_en("Destruir Rey Demonio", lawine, 1400).
test("Lawine NO recuerda 'Destruir Rey Demonio' en 1390", nondet) :- not(recuerda_en("Destruir Rey Demonio", lawine, 1390)).
test("Fern recuerda 'Destruir Rey Demonio' en 1400", nondet) :- recuerda_en("Destruir Rey Demonio", fern, 1400).

:- end_tests(tpIntegrador).
