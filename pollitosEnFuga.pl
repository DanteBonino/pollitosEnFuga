%Base de conocimientos:
animal(ginger, gallina(10, 5)).
animal(babs, gallina(8, 2)).
animal(bunty, gallina(23, 6)).
animal(mac, gallina(8, 7)).
animal(turuleca, gallina(15, 1)).
animal(rocky, gallo(animalDeCirco)).
animal(fowler, gallo(piloto)).
animal(oro, gallo(arrocero)).
animal(nick, rata).
animal(fetcher, rata).

granja(tweedys, [ginger, babs, bunty, mac, fowler]).
granja(delSol, [turuleca, oro, nick, fetcher]).

%Punto 1:
puedeCederle(UnAnimal, OtroAnimal):-
    esTrabajadora(UnAnimal),
    esHaragana(OtroAnimal).

esTrabajadora(UnAnimal):-
    cuantosHuevosPone(UnAnimal, 7). 

cuantosHuevosPone(UnAnimal, Huevos):-
    animal(UnAnimal,gallina(_,Huevos)).

esHaragana(UnAnimal):-
    cuantosHuevosPone(UnAnimal, Huevos),
    Huevos < 3.

%Punto 2:
animalLibre(Animal):-
    animal(Animal,_),
    not(viveEn(Animal, _)).

viveEn(Animal, Granja):-
    granja(Granja, Animales),
    member(Animal, Animales).

%Punto 3:
valoracionDeGranja(UnaGranja, UnaValoracion):-
    granja(UnaGranja,_),
    valoracionesDeLosAnimales(UnaGranja, Valoraciones),
    sum_list(Valoraciones, UnaValoracion).

valoracionesDeLosAnimales(UnaGranja, Valoraciones):-
    findall(Valoracion, valoracionDeAnimalPorGranja(UnaGranja, Valoracion), Valoraciones).

valoracionDeAnimalPorGranja(UnaGranja, Valoracion):-
    tipoDeAnimalQueViveEn(_, UnaGranja, TipoDeAnimal),
    valoracionPorTipo(TipoDeAnimal, Valoracion).

valoracionPorTipo(rata,0).
valoracionPorTipo(gallo(Profesion), 50):-
    sabeVolar(Profesion).
valoracionPorTipo(gallo(Profesion), 25):-
    not(sabeVolar(Profesion)).
valoracionPorTipo(gallina(Peso,Huevos),Valor):-
    Valor is Peso * Huevos.

sabeVolar(piloto).
sabeVolar(animalDeCirco).
%Preguntar sobre esto

%Punto 4:
granjaDeluxe(Granja):-
    granja(Granja, _),
    not(tieneAlgunaRata(Granja)),
    tieneMasDe50AnimalesOVale1000(Granja).

tieneAlgunaRata(Granja):-
    tipoDeAnimalQueViveEn(_,Granja,rata).

tieneMasDe50AnimalesOVale1000(Granja):-
    valoracionDeGranja(Granja, 1000).
tieneMasDe50AnimalesOVale1000(Granja):-
    granja(Granja, Animales),
    length(Animales, Cantidad),
    Cantidad > 50.

%Punto 5:
buenaPareja(UnAnimal, OtroAnimal):-
    tipoDeAnimalQueViveEn(UnAnimal, Granja, TipoAnimal),
    tipoDeAnimalQueViveEn(OtroAnimal, Granja, TipoDeOtroAnimal),
    sonCompatibles(animal(UnAnimal,TipoAnimal), animal(OtroAnimal,TipoDeOtroAnimal)).

sonCompatibles(animal(Nombre,rata),animal(OtroNombre,rata)):-
    Nombre \= OtroNombre.
sonCompatibles(animal(Nombre,gallina(Peso,_)),animal(OtroNombre,gallina(Peso,_))):-
    unaLePuedeCederALaOtra(Nombre, OtroNombre).
sonCompatibles(animal(_,gallo(Profesion)),animal(_,gallo(OtraProfesion))):-
    unoSabeVolarYElOtroNo(Profesion, OtraProfesion).

unaLePuedeCederALaOtra(Nombre,OtroNombre):-
    puedeCederle(Nombre,OtroNombre).
unaLePuedeCederALaOtra(Nombre,OtroNombre):-
    puedeCederle(OtroNombre,Nombre).

unoSabeVolarYElOtroNo(Profesion,OtraProfesion):-
    sabeVolar(Profesion),
    not(sabeVolar(OtraProfesion)).
unoSabeVolarYElOtroNo(Profesion,OtraProfesion):-
    sabeVolar(OtraProfesion),
    not(sabeVolar(Profesion)).

tipoDeAnimalQueViveEn(Animal, Granja,Tipo):-
    viveEn(Animal,Granja),
    animal(Animal, Tipo).

%Punto 6:
escapePerfecto(Granja):-
    granja(Granja,_),
    forall(viveEn(Animal,Granja),buenaPareja(Animal,_)),
    forall(tipoDeAnimalQueViveEn(UnAnimal,Granja,gallina(_,_)), poneMasHuevosQue(UnAnimal,5)).

poneMasHuevosQue(Animal, CantidadMinima):-
    cuantosHuevosPone(Animal, CantidadDeHuevos),
    CantidadMinima<CantidadDeHuevos.


%Logicamente escape perfecto es imposible si tiene gallinas, pq para que las gallinas sean buenas parejas, una le tiene que poder ceder a otra. Lo que significa que alguna gallina va a producir menos de 5 huevos.
