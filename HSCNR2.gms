Set
   i / ind1*ind12 /
   j / d1*d2 /;

Table c(i,j)

           d1              d2
   ind1   25.911465       51.557049
   ind2   25.893611       51.541222
   ind3   25.919639       51.491679
   ind4   25.903227       51.52268
   ind5   25.883797       51.556691
   ind6   25.91704        51.577825
   ind7   25.9248         51.514797
   ind8   25.914073       51.501477
   ind9   25.923982       51.544724
   ind10  25.925353       51.549304
   ind11  25.935201       51.52617
   ind12  25.896211       51.518356  ;

Variable OF, x, y;
Equation eq1(j);
*eq1..    OF   =E= sum((i,j), sqr(c(i,j)-(x)));
*eq1..    OF   =E= sum((i,j),sqrt(sqr(c(i,j)-(x))+sqr(c(i,j)-(y))));
eq1(j)..    OF   =E= sum((i),sqrt(sqr(c(i,'d1')-(x))+sqr(c(i,'d2')-(y))));

x.lo = 25;
x.up = 26;

y.lo = 51;
y.up = 52;

Model minlp1 / all /;
solve minlp1 using MINLP minimizing OF;

Display x.l, y.l, OF.l;