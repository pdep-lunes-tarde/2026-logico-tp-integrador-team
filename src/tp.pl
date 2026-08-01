

% ---------- Punto 1: la gente ----------

% a) Lo primero que vamos a necesitar modelar son los habitantes de los pueblos. De cada habitante es relevante saber en qué pueblo vive, cuándo nació y de qué raza es (humano, elfo, enano). Modelar a las siguientes personas:
% habitante(nombre, nacido, raza, pueblo)
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

% b) Queremos saber si una persona está viva en cierto año. Esto va a ser una estimación con base en cuál es el promedio de vida de las diferentes razas:
% los humanos viven 80 años
% los enanos 350 años
% los elfos pueden vivir indefinidamente, no mueren de viejos.
con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, elfo, _),
    Agno > Nacido.
con_vida(Nombre, Agno) :-
    habitante(Nombre, Nacido, Raza, _),
    promedio_vida(Raza, Prom),
    Agno > Nacido,
    Agno - Nacido =< Prom.

promedio_vida(humano, 80).
promedio_vida(enano, 350).


% ---------- Punto 2: los recuerdos ----------

% Conocemos las hazañas que ocurrieron en este mundo a través de quienes las recuerdan. Entonces, queremos modelar si alguien conoce una hazaña (incluyendo quiénes y dónde la realizaron), desde cuándo y cómo la conoce:
% Wirbel presenció en 1390 la hazaña rescatar a la hermana de Wirbel, llevada a cabo por Stark y Fern en Klares.
% Frieren también presenció en 1390 la hazaña rescatar a la hermana de Wirbel, llevada a cabo por Stark y Fern en Klares.
% Lawine escuchó en 1393 una canción sobre la hazaña destruir al demonio Aura, llevada a cabo por Frieren en Weise.
% Voll leyó en 1400 un libro de 50 páginas sobre la hazaña destruir al demonio Aura, llevada a cabo por Denken en Auberst.
% Serie leyó en 1335 un libro de 100 páginas sobre la hazaña destruir al Rey Demonio, llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen.
% Kanne presenció en 1375 la hazaña recuperar al gato perdido, llevada a cabo en Weise por Himmel y Frieren.
% hazagna(nombre, participes, lugar)
% conoce(persona, ↑ hazagna ↑, forma_de_recordar, agno)
% eg: hazagna("Rescatar hermana Wirbel", participes(stark, fern), klares).

conoce(wirbel, hazagna("Rescatar hermana Wirbel", participes(stark, fern), klares), presenciar, 1390).
conoce(frieren, hazagna("Rescatar hermana Wirbel", participes(stark, fern), klares), presenciar, 1390).
conoce(lawine, hazagna("Destruir demonio Aura", participes(frieren), weise), escuchar, 1393).
conoce(voll, hazagna("Destruir demonio Aura", participes(denken), auberst), leer(50), 1400).
conoce(serie, hazagna("Destruir Rey Demonio", participes(frieren, himmel, heiter, eisen), ende), leer(100), 1335).
conoce(kanne, hazagna("Recuperar gato perdido", participes(himmel, frieren), weise), presenciar, 1375).

% a) Queremos poder contestar sí una hazaña es recordada por alguien en cierto año, sabiendo que:
% si una persona presenció una hazaña, la recuerda desde ese momento por el resto de su vida.
% si una persona escuchó una canción sobre una hazaña, la recuerda por 15 años.
% si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como páginas tenga el libro.
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

% b) Queremos contestar sí una hazaña está o no corroborada. Una hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas que la conocieron con distintos detalles (ya sea diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña). No importa el año o si las personas las recuerdan al mismo tiempo para esto.
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

% c) Queremos saber si en cierto año una hazaña pasó al olvido, lo cuál ocurre si ya nadie la recuerda en ese año.
olvidada_en(Nombre_Hazagna, Agno) :- 
    conoce(_, hazagna(Nombre_Hazagna, _, _), _, _),
    not(recuerda_en(Nombre_Hazagna, _, Agno)).


% ---------- Punto 3: conmemorando hazañas ----------

% Algunos pueblos decidieron conmemorar hazañas de diferentes maneras para evitar que pasen al olvido.
% El pueblo de Weise conmemora la hazaña destruir al rey demonio (llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen) con un día festivo. Esta celebración comenzó en el año 1340.
% El pueblo de Auberst construyó estatuas:
% en 1370 la estatua de bronce “el equipo de heroes”, conmemorando la hazaña destruir al rey demonio llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen. A esta estatua se le hizo mantenimiento en el año 1400 y en el 1450.
% en 1340 la estatua de mármol “el héroe del sur” conmemorando la hazaña destruir a Schlat el Omnisciente, llevada a cabo en Ende por el Héroe del Sur. A esta estatua se le hizo mantenimiento en el año 1410.
%conmemora(pueblo, forma (y su data), agno_inicio,
%   hazagna)
conmemora(weise, dia_festivo, 1340, 
    hazagna("Destruir Rey Demonio", participes(frieren, himmel, heiter, eisen), ende)).
conmemora(auberst, estatua(bronce, "el equipo de heroes", mantenimiento(1400, 1450)), 1370,
    hazagna("Destruir Rey Demonio", participes(frieren, himmel, heiter, eisen), ende)).
conmemora(auberst, estatua(marmol, "el héroe del sur", mantenimiento(1410)), 1340,
    hazagna("Destruir Schlat Omnisciente", participes(heroe_del_sur), ende)).

% ↑↑↑
% a) Agregar a la base de conocimientos las maneras en las que los pueblos conmemoran las hazañas.

% b) Además de lo dicho en el punto 2, agregar que una persona también conoció una hazaña si:
% en el pueblo en el que vive se celebra un día festivo conmemorando la hazaña. Estas hazañas las recuerdan toda su vida, igual que las hazañas que fueron presenciadas.
% en el pueblo en el que vive hay alguna estatua que conmemora la hazaña. Estas hazañas son recordadas si la estatua sigue en buen estado.

% hazagna(nombre, participes, lugar)
% conoce(persona, ↑ hazagna ↑, forma_de_recordar, agno) ESTAS SIN EL AÑO (podría agregarse igual)
conoce(Nombre, hazagna(Nombre_Hazagna, _, _), dia_festivo, Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, dia_festivo, Agno_Conmemora, hazagna(Nombre_Hazagna, _, _)),
    con_vida(Nombre, Agno_Conmemora), 
    AgnoConoce is min_member(Agno_Nacido, Agno_Conmemora). % de guía de lenguajes
conoce(Nombre, hazagna(Nombre_Hazagna, _, _), estatua(_, _, _), Agno_Conoce) :- 
    habitante(Nombre, Agno_Nacido, _, Pueblo),
    conmemora(Pueblo, estatua, Agno_Conmemora, hazagna(Nombre_Hazagna, _, _)),
    con_vida(Nombre, Agno_Conmemora), 
    AgnoConoce is min_member(Agno_Nacido, Agno_Conmemora).


recuerda_en(Nombre_Hazagna, Nombre, Agno) :-
    con_vida(Nombre, Agno),
    conoce(Nombre, hazagna(Nombre_Hazagna, _, _), dia_festivo, Agno_Conoce),
    Agno_Conoce =< Agno.

%  Una estatua está en buen estado…:
% sí es de mármol, si tuvo un mantenimiento o fue construida hace no más de 30 años.
% sí es de bronce, si tuvo un mantenimiento o fue construida hace no más de 15 años.

% En ambos casos, la persona conoció la hazaña en el momento en que comenzó a conmemorarse. Si la persona aún no había nacido en ese año, la conoció en el año en que nació.

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



% -- Pruebas punto 1:
% Kanne (humana, nacida en 1365) está viva en 1370.
% Kanne no está viva en 1300, porque todavía no había nacido.
% Kanne no está viva en 2000, porque ya habría muerto.
% Voll está vivo en 1550 ya que nació en 1200 y por ser enano vive 350 años.
% Voll ya no está vivo en 1551.
% Serie está viva en el año 5000 porque los elfos no mueren de viejos.

% -- Pruebas punto 2:
% Lawine no recuerda destruir al demonio Aura en 1380 porque aún no escuchó una canción sobre esa hazaña.
% Lawine recuerda destruir al demonio Aura en 1400
% Lawine ya no recuerda destruir al demonio Aura en 1410, porque pasaron más de 15 años de que escuchó la canción
% Voll recuerda destruir al demonio Aura en 1450
% Voll no recuerda destruir al demonio Aura en 1460
% Wirbel recuerda rescatar a la hermana de wirbel en 1430
% Wirbel ya no recuerda rescatar a la hermana de wirbel en 1440 porque no está vivo en ese año
% rescatar a la hermana de Wirbel es una hazaña corroborada
% destruir al demonio Aura no es una hazaña corroborada (las diferentes personas que la conocen no están de acuerdo ni en lugar ni en los héroes que la llevaron a cabo)
% destruir al demonio Aura pasó al olvidó en 1460
% destruir al demonio Aura no pasó al olvidó en 1440

% -- Pruebas punto 3:
% Lawine recuerda destruir al rey demonio en 1400 ya que vive en Auberst y allí hay una estatua en buen estado conmemorando la hazaña
% Pero, en 1390 Lawine no recuerda destruir al rey demonio porque la estatua no se encuentra en buen estado en ese momento
% Fern recuerda destruir al rey demonio en 1400 porque vive en Weise y allí se conmemora esa hazaña con un día festivo

:- end_tests(tpIntegrador).
