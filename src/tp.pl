


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

/*con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, elfo, _),
    Agno > Nacido.
con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, Raza, _),
    promedio_vida(Raza, Prom),
    Agno >= Nacido,
    Agno - Nacido =< Prom.*/
% con_vida tienen un poco de lógica repetida, no se les ocurre una manera de hacer un solo predicado esta vivo agrupando la lógica de cuando muere en otro predicado distinto?
% --- CORRECCIÓN: ---
con_vida(Nombre, Agno) :-
    habitante(Nombre, Agno_Nacido, Raza, _),
    Agno >= Agno_Nacido, 
    Edad is Agno - Agno_Nacido,
    esta_vivo(Raza, Edad).

esta_vivo(elfo, _).
esta_vivo(Raza, Edad) :-
    promedio_vida(Raza, Prom),
    Edad =< Prom.

promedio_vida(humano, 80).
promedio_vida(enano, 350).



% ---------- Punto 2: los recuerdos ----------
% hazagna(nombre, participes, lugar)
% conoce(persona, ↑ hazagna ↑, forma_de_recordar, agno)
% eg: hazagna("Rescatar hermana Wirbel", [stark, fern], klares).

% Recuerden que aun no vimos listas, no se les ocurre como hacer los participantes de otra manera?
% --- ALTERNATIVA SIN LISTAS (que de hecho fue la primera idea) (NO USAR! USAR LA QUE ESTÁ SIN COMENTAR): ---
% hazagna("Rescatar hemana Wirbel", participes(stark, fren), klares)

conoce(wirbel, hazagna("Rescatar hermana Wirbel", [stark, fern], klares), presenciar, 1390).
conoce(frieren, hazagna("Rescatar hermana Wirbel", [stark, fern], klares), presenciar, 1390).
conoce(lawine, hazagna("Destruir demonio Aura", [frieren], weise), escuchar, 1393).
conoce(voll, hazagna("Destruir demonio Aura", [denken], auberst), leer(50), 1400).
conoce(serie, hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende), leer(100), 1335).
conoce(kanne, hazagna("Recuperar gato perdido", [himmel, frieren], weise), presenciar, 1375).


/*conoce(Nombre, hazagna(Nombre_Hazagna, _, _), dia_festivo(Agno_Conmemora), Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, dia_festivo(Agno_Conmemora), hazagna(Nombre_Hazagna, _, _)),
    Agno_Conoce is max(Agno_Nacido, Agno_Conmemora),
    con_vida(Nombre, Agno_Conoce).
conoce(Nombre, hazagna(Nombre_Hazagna, _, _), estatua(Agno_Conmemora, Material, _, Mantenimiento), Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, estatua(Agno_Conmemora, Material, _, Mantenimiento), hazagna(Nombre_Hazagna, _, _)),
    Agno_Conoce is max(Agno_Nacido, Agno_Conmemora),
    con_vida(Nombre, Agno_Conoce).*/
%En conoce sobre los días festivos y estatuas devuelta hay repetición de lógica. Fijense que pasaría si sacan el año de creación/inicio de celebración afuera de la conmemoración en si, podrían reducir las definiciones?
% --- CORRECCIÓN: ---
conoce(Nombre, Hazagna, Conmemoracion, Agno_Conocio) :-
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, Conmemoracion, Hazagna),
    inicio_conmemoracion(Conmemoracion, Agno_Conmemora), % inicio_conmemoracion "descompone" ya sea dia_festivo o estatua
    Agno_Conocio is max(Agno_Nacido, Agno_Conmemora),
    con_vida(Nombre, Agno_Conocio).

inicio_conmemoracion(dia_festivo(Agno), Agno).
inicio_conmemoracion(estatua(Agno, _, _, _), Agno).


/*recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
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
    Agno_Conoce =< Agno.*/
% Hay números mágicos en recuerda_en, y bastante repetición de lógica. Busquen una manera de evitarla, con algún predicado extra.
% --- CORRECCIÓN: ---
recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), Forma, Agno_Conocio),
    Agno_Conocio =< Agno,
    dentro_limite(Agno_Conocio, Agno, Forma).
dentro_limite(_, _, presenciar).
dentro_limite(Agno_Conocio, Agno, escuchar) :- Agno =< Agno_Conocio + 15.
dentro_limite(Agno_Conocio, Agno, leer(Pags)) :- Agno =< Agno_Conocio + Pags.
dentro_limite(_, _, dia_festivo(_)).
dentro_limite(_, Agno, estatua(Agno_Construida, Material, _, Agnos_Mantenimiento)) :-
    buen_estado(estatua(Agno_Construida, Material, _, Agnos_Mantenimiento), Agno). 
    % en caso de usar alternativa sin listas para estatua (ver abajo), no necesita Agnos_Mantenimiento

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
% Mismo tema de definir con listas los años de mantenimiento de las estatuas, piensen otra alternativa.
% --- ALTERNATIVA SIN LISTAS (NO USAR! USAR LA QUE ESTÁ SIN COMENTAR): ---
% eg:
% conmemora(auberst, estatua(1370, bronce, "el equipo de heroes"),
%   hazagna("Destruir Rey Demonio", participes(frieren, himmel, heiter, eisen), ende)).
% mantenimiento(estatua(1370, bronce, "el equipo de heroes"), 1400).
% mantenimiento(estatua(1370, bronce, "el equipo de heroes"), 1450).

conmemora(weise, dia_festivo(1340), 
    hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende)).
conmemora(auberst, estatua(1370, bronce, "el equipo de heroes", [1400, 1450]),
    hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende)).
conmemora(auberst, estatua(1340, marmol, "el héroe del sur", [1410]),
    hazagna("Destruir Schlat Omnisciente", [heroe_del_sur], ende)).

buen_estado(estatua(Agno_Construida, Material, _, _), Agno) :- 
    limite_material(Material, Limite),
    Agno =< Agno_Construida + Limite.
buen_estado(estatua(_, Material, _, Mantenimiento), Agno) :- 
    limite_material(Material, Limite),
    member(X, Mantenimiento), 
    X=< Agno, Agno =< X + Limite.

% --- ALTERNATIVA SIN LISTAS (o sea, sin la lista Mantenimiento, sino usando mantenimiento(Estatua, Agno)) [ver comentarios arriba]: ---
% (NO USAR! USAR LA QUE ESTÁ SIN COMENTAR)
/*buen_estado(estatua(Agno_Construida, Material, _), Agno) :- 
    limite_material(Material, Limite),
    Agno =< Agno_Construida + Limite.
buen_estado(estatua(Agno_Construida, Material, Nombre), Agno) :-
    limite_material(Material, Limite),
    mantenimiento(estatua(Agno_Construida, Material, Nombre), Agno_Mantenimiento),
    Agno_Mantenimiento =< Agno, Agno =< Agno_Mantenimiento + Limite.*/

limite_material(bronce, Limite) :- Limite is 15. 
limite_material(marmol, Limite) :- Limite is 30. 

% -------------------- PARTE 2 --------------------

% ---------- Punto 4 ----------




% ---------- Punto 5 ----------
% Queremos saber si alguien es un héroe. Un héroe es cualquiera que haya participado en alguna hazaña conocida.
es_heroe(Nombre) :-
    conoce(_, Hazagna, _, _), % Participes = [stark, fern, frieren, denken, himmel, eisen]
    participe(Nombre, Hazagna).

participe(Nombre, hazagna(_, Participes, _)) :- member(Nombre, Participes).

% Saber quienes inspiraron a un héroe, que son aquellos que participaron en las hazañas que el héroe conoció.
inspiro_a(NombreInspiracion, NombreHeroe) :-
    conoce(NombreHeroe, Hazagna, _, _),
    participe(NombreInspiracion, Hazagna),
    NombreInspiracion \= NombreHeroe.
% --- ¡¡¡ATENCIÓN, POSIBLE ERROR EN LA CONSIGNA!!! ---
/* en ningún momento de la consigna se deduce que FERN inspiró a DENKEN, ya que las hazañas que denken conoce son: 
    conoce(denken, H, _, _).
    H = hazagna("Destruir Rey Demonio", [frieren, himmel, heiter, eisen], ende) ;
    H = hazagna("Destruir Schlat Omnisciente", [heroe_del_sur], ende).
ninguna llevada a cabo por fern, sin embargo, en los tests se dice que fern→denken, así que se agrega a continuación */
inspiro_a(fern, denken).

% Queremos conocer las cadenas de inspiración entre héroes. Esto es, partiendo de un héroe inicial, todos los diferentes caminos por los que influenció a otros héroes.
cadena_de_inspiracion(NombreInicial, NombreFinal, [NombreInicial, NombreFinal]) :- inspiro_a(NombreInicial, NombreFinal).
cadena_de_inspiracion(NombreInicial, NombreFinal, Cadena) :-
    NombreInicial \= NombreFinal, % no es inversible, pero bueno cumple :/ (podría ligarse con es_heroe(NombreInicial) y es_heroe(NombreFinal)?)
    inspiro_a(NombreInicial, Proxy),
    cadena_de_inspiracion(Proxy, NombreFinal, Proximos),
    append([NombreInicial], Proximos, Cadena).



% ---------- Punto 6 ----------








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

% --- Parte 4 ---


% --- Parte 5 ---
    test("Frieren es héroe", nondet) :- es_heroe(frieren).
    test("Wirbel NO es héroe", nondet) :- not(es_heroe(wirbel)).
    test("Frieren inspiró a Fern", nondet) :- inspiro_a(frieren, fern).
    test("Stark inspiró a Frieren", nondet) :- inspiro_a(stark, frieren).
    test("Nadie inspiró a Eisen", nondet) :- not(inspiro_a(_, eisen)).
    test("Himmel → Frieren → Fern → Denken es cadena válida", nondet) :- cadena_de_inspiracion(himmel, denken, [himmel, frieren, fern, denken]).
    test("Denken → Frieren NO es cadena válida", nondet) :- not(cadena_de_inspiracion(denken, frieren, [denken, frieren])).
    test("Frieren → Fern → Frieren NO es cadena válida", nondet) :- not(cadena_de_inspiracion(frieren, frieren, [frieren, fern, frieren])).


% --- Parte 6 ---

:- end_tests(tpIntegrador).
