$title Multi-objective Economic-Environmental Load Dispatch

Set
   Gen     / g1*g12  /
   counter / c1*c12 /;

Parameter report(*), rep(counter,*), rep2(counter,gen);


Table data(Gen,*)

        Lat               Lon
   G1   25.911465         51.557049
   G2   25.893611         51.541222
   G3   25.919639         51.491679
   G4   25.903227         51.52268
   G5   25.883797         51.556691
   G6   25.91704          51.577825
   G7   25.9248           51.514797
   G8   25.914073         51.501477
   G9   25.923982         51.544724
   G10  25.925353         51.549304
   G11  25.935201         51.52617
   G12  25.896211         51.518356  ;


Variable x, y, P(gen), OF, TE, TC;
Equation eq1, eq2, eq3;
eq1.. OF =e=   1;

*eq1.. TC =e= sum(gen, data(gen,'Lat')*P(gen)*P(gen) + data(gen,'Lon')*P(gen));
*eq1.. OF =E= sum(sqrt(sqr(gen,(x-data(gen,'Lat')))+ sqr(gen,(y-data(gen,'Lon'))))) ;
*eq2.. sum(gen, P(gen)) =g= load;
*eq3.. TE =e= sum(gen, data(gen,'d')*P(gen)*P(gen) + data(gen,'e')*P(gen) + data(gen,'f'));



Model END / eq1, eq2, eq3 /;
display OF.l;

*solve END using NLP minimizing OF;
*display x.l, y.l;
*report('maxTE') = TE.l;
*report('minTC') = TC.l;




$onText
loop(counter,
   Elim  = (report('maxTE') - report('minTE'))*((ord(counter) - 1)/(card(counter) - 1)) + report('minTE');
   TE.up =  Elim;
   solve END using qcp minimizing TC;
   rep(counter,'TC') = TC.l;
   rep(counter,'TE') = TE.l;
   rep2(counter,gen) = P.l(gen);
);
display rep, rep2;

$offText
