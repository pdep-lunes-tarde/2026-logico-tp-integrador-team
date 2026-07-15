
% ---------- Punto 1: la gente ----------

% a) Lo primero que vamos a necesitar modelar son los habitantes de los pueblos. De cada habitante es relevante saber en qué pueblo vive, cuándo nació y de qué raza es (humano, elfo, enano). Modelar a las siguientes personas:

% Denken, un humano nacido en el año 1290 que vive en Auberst.
% Voll, un enano nacido en el año 1200 que vive en Ende.
% Serie, una elfa nacida en el año 500 que vive en Weise.
% Fern, una humana nacida en el año 1370 que vive en Weise.
% Stark, un humano nacido en el año 1368 que vive en Riegel.
% Lawine, una humana nacida en el año 1372 que vive en Auberst.
% Kanne, una humana nacida en el año 1365 que vive en Weise.
% Wirbel, un humano nacido en el año 1350 que vive en Klares.
% Lernen, un humano nacido en el año 1315 que vive en Auberst.
% Frieren, una elfa nacida en el año 100 que vive en Weise.
% Eisen, un enano nacido en el año 1150 que vive en Riegel.


% b) Queremos saber si una persona está viva en cierto año. Esto va a ser una estimación con base en cuál es el promedio de vida de las diferentes razas:

% los humanos viven 80 años
% los enanos 350 años
% los elfos pueden vivir indefinidamente, no mueren de viejos.
% Entonces, una persona está viva en un año dado si nació antes en ese año o antes y todavía no murió.



% ---------- Punto 2: los recuerdos ----------

% Conocemos las hazañas que ocurrieron en este mundo a través de quienes las recuerdan. Entonces, queremos modelar si alguien conoce una hazaña (incluyendo quiénes y dónde la realizaron), desde cuándo y cómo la conoce:

% Wirbel presenció en 1390 la hazaña rescatar a la hermana de Wirbel, llevada a cabo por Stark y Fern en Klares.
% Frieren también presenció en 1390 la hazaña rescatar a la hermana de Wirbel, llevada a cabo por Stark y Fern en Klares.
% Lawine escuchó en 1393 una canción sobre la hazaña destruir al demonio Aura, llevada a cabo por Frieren en Weise.
% Voll leyó en 1400 un libro de 50 páginas sobre la hazaña destruir al demonio Aura, llevada a cabo por Denken en Auberst.
% Nota: Voll conoce una versión diferente de la hazaña que conoce Lawine, ya que con el tiempo se fueron perdiendo o cambiando detalles de la misma.
% Serie leyó en 1335 un libro de 100 páginas sobre la hazaña destruir al Rey Demonio, llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen.
% Kanne presenció en 1375 la hazaña recuperar al gato perdido, llevada a cabo en Weise por Himmel y Frieren.


% a) Queremos poder contestar sí una hazaña es recordada por alguien en cierto año, sabiendo que:

% si una persona presenció una hazaña, la recuerda desde ese momento por el resto de su vida.
% si una persona escuchó una canción sobre una hazaña, la recuerda por 15 años.
% si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como páginas tenga el libro.        


% b) Queremos contestar sí una hazaña está o no corroborada. Una hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas que la conocieron con distintos detalles (ya sea diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña). No importa el año o si las personas las recuerdan al mismo tiempo para esto.


% c) Queremos saber si en cierto año una hazaña pasó al olvido, lo cuál ocurre si ya nadie la recuerda en ese año.



% ---------- Punto 3: conmemorando hazañas ----------


% Algunos pueblos decidieron conmemorar hazañas de diferentes maneras para evitar que pasen al olvido.

% El pueblo de Weise conmemora la hazaña destruir al rey demonio (llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen) con un día festivo. Esta celebración comenzó en el año 1340.
% El pueblo de Auberst construyó estatuas:
% en 1370 la estatua de bronce “el equipo de heroes”, conmemorando la hazaña destruir al rey demonio llevada a cabo en Ende por Frieren, Himmel, Heiter y Eisen.
% A esta estatua se le hizo mantenimiento en el año 1400 y en el 1450.

% en 1340 la estatua de mármol “el héroe del sur” conmemorando la hazaña destruir a Schlat el Omnisciente, llevada a cabo en Ende por el Héroe del Sur.
% A esta estatua se le hizo mantenimiento en el año 1410.


% a) Agregar a la base de conocimientos las maneras en las que los pueblos conmemoran las hazañas.


% b) Además de lo dicho en el punto 2, agregar que una persona también conoció una hazaña si:

% en el pueblo en el que vive se celebra un día festivo conmemorando la hazaña. Estas hazañas las recuerdan toda su vida, igual que las hazañas que fueron presenciadas.
% en el pueblo en el que vive hay alguna estatua que conmemora la hazaña. Estas hazañas son recordadas si la estatua sigue en buen estado.

%  Una estatua está en buen estado…:
% sí es de mármol, si tuvo un mantenimiento o fue construida hace no más de 30 años.
% sí es de bronce, si tuvo un mantenimiento o fue construida hace no más de 15 años.

% En ambos casos, la persona conoció la hazaña en el momento en que comenzó a conmemorarse. Si la persona aún no había nacido en ese año, la conoció en el año en que nació.


:- begin_tests(tpIntegrador, []).

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
