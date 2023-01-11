/* Bagian I */
/* Deklarasi Fakta */
/* Pria */
pria(gede).
pria(gojo).
pria(vonNeumann).
pria(vanRossum).
pria(bambang).
pria(vito).
pria(ave).
pria(wesly).
pria(elonMusk).
pria(patrick).
/* Wanita */
wanita(indah).
wanita(lovelace).
wanita(khelli).
wanita(power).
wanita(aqua).
wanita(wulandari).
wanita(anya).
/* Usia */
usia(gede,96).
usia(indah,92).
usia(gojo,90).
usia(lovelace,79).
usia(khelli,89).
usia(vonNeumann,92).
usia(vanRossum,65).
usia(bambang,60).
usia(vito,56).
usia(power,50).
usia(ave,54).
usia(aqua,50).
usia(wulandari,24).
usia(wesly,26).
usia(elonMusk,28).
usia(patrick,24).
usia(anya,4).
/* Menikah */
menikah(gede,indah).
menikah(indah,gede).
menikah(gojo,lovelace).
menikah(lovelace,gojo).
menikah(khelli,vonNeumann).
menikah(vonNeumann,khelli).
menikah(vito,power).
menikah(power,vito).
menikah(ave,aqua).
menikah(aqua,ave).
menikah(wulandari,wesly).
menikah(wesly,wulandari).
/* Anak */
anak(vanRossum,gede).
anak(vanRossum,indah).
anak(bambang,gede).
anak(bambang,indah).
anak(vito,gede).
anak(vito,indah).
anak(power,gojo).
anak(power,lovelace).
anak(ave,gojo).
anak(ave,lovelace).
anak(aqua,khelli).
anak(aqua,vonNeumann).
anak(wesly,vito).
anak(wesly,power).
anak(elonMusk,ave).
anak(elonMusk,aqua).
anak(patrick,ave).
anak(patrick,aqua).
anak(anya,wulandari).
anak(anya,wesly).
/* Saudara */
saudara(vanRossum,bambang).
saudara(bambang,vanRossum).
saudara(bambang,vito).
saudara(vito,bambang).
saudara(vito,vanRossum).
saudara(vanRossum,vito).
saudara(power,ave).
saudara(ave,power).
saudara(elonMusk,patrick).
saudara(patrick,elonMusk).

/* Deklarasi Rules */
/* X adalah kakak dari Y jika mereka besudara dan X lebih tua dari Y */
kakak(X,Y) :- saudara(X,Y), usia(X,V), usia(Y,W), V > W.
/* X adalah keponakan dari Y jika Y dan Z bersaudara dan Z memiliki anak X */
keponakan(X,Y) :- saudara(Z,Y), anak(X,Z).
/* X adalah suami Y jika X dan Y menikah dan X laki-laki */
suami(X,Y) :- menikah(X,Y), pria(X).
/* X adalah sepupu Y jika X adalah anak A, Y adalah anak B, tetapi A dan B bersaudara */
sepupu(X,Y) :- anak(X,A), anak(Y,B), saudara(A,B).
/* X adalah menantu Y jika Y punya anak Z dan Z menikah dengan X */
menantu(X,Y) :- anak(Z,Y), menikah(X,Z).
/* X adalah orangtua Y jika Y adalah anak X */
orangtua(X,Y) :- anak(Y,X).
/* X adalah bibi dari Y jika Y adalah keponakan X dan X perempuan */
bibi(X,Y) :- saudara(X,Z), anak(Y,Z), wanita(X).
/* X adalah cucu Y jika X adak dari Z dan Z anak dari Y */
cucu(X,Y) :- anak(X,Z), anak(Z,Y).
/* X adalah keturunan dari Y jika X anak Y, atau X cucu Y, atau X cicit Y, dst */
keturunan(X,Y) :- anak(X,Y); anak(X,Z), keturunan(Z,Y).
/* X adalah anak sulung jika X adalah anak paling tua dari seluruh saudaranya */
anaksulung(X) :- anak(X,Y), wanita(Y), \+ kakak(_,X).
/* X adalah anak bungsu jika X adalah anak paling muda dari seluruh saudaranya */
anakbungsu(X) :- anak(X,Y), wanita(Y), \+ kakak(X,_).

/* Bagian II */
/* Deklarasi Fakta dan Rules */
/* 1. Combinations */
combination(_A,_B,1) :- (_B == 0),!.
combination(A,A,1).
combination(A,B,X) :- (A>B), (B>0),
    P is (A - 1), Q is (B - 1),
    combination(P,B,W), combination(P,Q,Z),
    X is (W + Z),!.

/* 2. Change */
change(0,0).
change(X,A) :- (A>=5),
    R is (A - 5), change(N,R),
    X is (N + 1).
change(X,A) :- (A>=2), (A<5),
    R is (A - 2), change(N,R),
    X is (N + 1).
change(X,A) :- (A>=1), (A<2),
    R is (A - 1), change(N,R),
    X is (N + 1).

/* 3. FPB */
fpb(A,0,A).
fpb(_A,1,1).
fpb(A,A,A).
fpb(A,B,X) :- (A<B), fpb(B,A,X).
fpb(A,B,X) :- (A>B), (B>0),
    mod(A,B,R), fpb(B,R,X),!.

/* 4. Modulo */
mod(_A,_B,_X) :- (_A == 0), (_B == 0),!,fail.
mod(_A,_B,0) :- ((_B == 1) ; (_A == 0)),!.
mod(A,_B,0) :- (A == _B),!.

mod(A,B,X) :- (A<B), (B<0),
    P is (A - B), mod(P,B,X),(X =< 0),!.
mod(A,B,X) :- (A<B), (A<0), (B>0),
    P is (A + B), mod(P,B,X), (X >= 0),!.
mod(A,B,A) :- (((A<B), (A>0)) ; ((A>B), (A<0))),!.
mod(A,B,X) :- (A>B), (B<0), (A>0),
    P is (A + B), mod(P,B,X), (X =< 0),!.
mod(A,B,X) :- (A>B), (B>0),
    P is (A - B), mod(P,B,X),!.

/* 5. Deret */
deret(1,1).
deret(A,Y) :- mod(A,2,0),
    P is (A - 1), deret(P,Z),
    Y is (Z + 1).
deret(A,Y) :- mod(A,2,1),
    P is (A - 1), deret(P,Z),
    Y is (Z * 2).

/* Bagian III */
/* Deklarasi fakta dan rules */
/* A. Statistik List */
/* 1. Min */
min([First],First).
min([First | Item], First) :- min(Item, Minimum), First < Minimum.
min([First | Item], Minimum) :- min(Item, Minimum), First >= Minimum.

/* 2. Max */
max([First],First).
max([First | Item], First) :- max(Item, Minimum), First > Minimum.
max([First | Item], Minimum) :- max(Item, Minimum), First =< Minimum.

/* 3. Range */
range([_First], 0).
range([First | Item], Range) :- 
    max([First | Item], Maksimum), min([First | Item], Minimum),
    Range is (Maksimum - Minimum).

/* 4. Count */
count([_First], 1).
count([_First | Item], Count) :-
    count(Item, _Jumlah),
    Count is (_Jumlah + 1).

/* 5. Sum */
sum([First], First).
sum([First | Item], Sum) :-
    sum(Item, Total),
    Sum is (First + Total).

/* B. List and Queue Manipulation */
/* 1. Get Index */
getIndex([First],First,1).
getIndex([First | _Item], Cari, 1) :- (First =:= Cari).
getIndex([First | Item], Cari, Index) :- (First \= Cari),
    getIndex(Item, Cari, Indeks), 
    Index is (Indeks + 1).

/* 2. Swap */
/* Prosedur tambahan */
/* getValue, mendapatkan nilai dari suatu indeks */
getValue([First], 1, First).
getValue([First | _Item], 1, First).
getValue([_First | Item], Index, Value) :- (Index > 1),
    Indeks is (Index - 1),
    getValue(Item, Indeks, Value),!.

/* concat, menggabungkan suatu elemen ke dalam list (depan) */
concat(A,[],[A]).
concat(A,[X|B],[A|[X|B]]).

/* concatList, menggabungkan dua buah list */
concatList([], X, X).
concatList([X|Y], Z, [X|W]) :- concatList(Y, Z, W).

/* slice, memotong sebuah list dengan indeks tertentu */
slice([],_X,_Y,[]).
slice([_A|_B],1,1,[]).
slice([_A|_B],_X,1,[]).
slice([_A|_B],1,_Y1,R1) :- _Y is _Y1 - 1, slice(_B,_X,_Y,R), concat(_A,R,R1),!.
slice([_A|_B],_X1,_Y1,R) :- _X is _X1 - 1, _Y is _Y1 - 1, slice(_B,_X,_Y,R),!.

/* push, menambahkan suatu nilai ke dalam list (belakang) */
push(X, [], [X]).
push(Z, [X|Y], [X|W]) :- push(Z,Y,W).

/* Program utama */
swap(Tugas, Idx1, Idx1, Tugas).
swap(Tugas, Idx1, Idx2, Hasil) :- (Idx1 > Idx2),
    swap(Tugas, Idx2, Idx1, Hasil).
swap(Tugas, Idx1, _Idx2, _Hasil) :- \+ getValue(Tugas, Idx1, _),!,fail.
swap(Tugas, _Idx1, Idx2, _Hasil) :- \+ getValue(Tugas, Idx2, _),!,fail.
swap(Tugas, Idx1, Idx2, Hasil) :- (Idx1 < Idx2),
    Perantara1 is (Idx1 + 1), Perantara2 is (Idx2 + 1), count(Tugas, X), Akhir is (X + 1),
    slice(Tugas, 1, Idx1, PotAwal), slice(Tugas, Perantara1, Idx2, PotMid), slice(Tugas, Perantara2, Akhir, PotAkhir),
    getValue(Tugas, Idx1, Nilai1), getValue(Tugas, Idx2, Nilai2),
    push(Nilai2,PotAwal,Hasil1),
    concatList(Hasil1,PotMid,Hasil2),
    push(Nilai1,Hasil2,Hasil3),
    concatList(Hasil3,PotAkhir,Hasil),!.

/* 3. Split List */
splitList([First],[First],[]) :- mod(First,2,1).
splitList([First],[],[First]) :- mod(First,2,0).
splitList([First | Item],[First | X],Genap) :- mod(First,2,1),
    splitList(Item,X,Genap).
splitList([First | Item],Ganjil,[First | Y]) :- mod(First,2,0),
    splitList(Item,Ganjil,Y).

/* Bagian IV - Bonus */
/* Implementasi kalkulator */
% Dynamic variables
:- dynamic(lama/1).
:- dynamic(baru/1).

% Inisiasi awal
lama(_S).
baru(_S).

% Fungsi tambahan printTemplate, biar sesuai sama template dan switching nilai
printTemplate(Old,New) :- 
    write('Old Saved Value is '),write(Old),nl,
    write('New Saved Value is '),write(New),
    assertz(lama(New)),
    retract(lama(Old)),
    retract(baru(Old)).

% Fungsional kalkulator sesuai spesifikasi
startCalculator :- 
    lama(_X), baru(_Y), retractall(lama(_)), retractall(baru(_)),
    assertz(lama(0)), assertz(baru(0)),
    write('Selamat Datang di Kalkulator Prolog!'),nl,
    write('Currently Saved Value is '),lama(X),write(X),!.

add(_X) :-
    lama(_Old), var(_Old),!,fail.
add(X) :- 
    lama(Old),
    Baru is (Old + X),
    assertz(baru(Baru)),
    printTemplate(Old,Baru),!.

subtract(_X) :-
    lama(_Old), var(_Old),!,fail.
subtract(X) :- 
    lama(Old),
    Baru is (Old - X),
    assertz(baru(Baru)),
    printTemplate(Old,Baru),!.

multiply(_X) :-
    lama(_Old), var(_Old),!,fail.
multiply(X) :- 
    lama(Old),
    Baru is (Old * X),
    assertz(baru(Baru)),
    printTemplate(Old,Baru),!.

divide(_X) :-
    lama(_Old), var(_Old),!,fail.
divide(X) :- 
    lama(Old),
    Baru is (Old / X),
    assertz(baru(Baru)),
    printTemplate(Old,Baru),!.

getValue :-
    baru(_New), var(_New),!,fail.
getValue :-
    baru(New),
    write('Currently Saved Value is '),write(New).

clearCalculator :-
    lama(_Old), var(_Old),!,fail.
clearCalculator :-
    lama(Old), baru(_New),
    assertz(baru(0)),
    printTemplate(Old,0),!.

exitCalculator :-
    lama(_Old), var(_Old),!,fail.
exitCalculator :-
    lama(_Old), baru(_New),
    write('Terima Kasih telah Menggunakan Kalkulator Prolog'),
    retractall(lama(_)),
    retractall(baru(_)).