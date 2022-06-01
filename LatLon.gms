$title Great Circle Distances (GREAT,SEQ=73)

$onText
The coordinates of points (airports) on the globe are given in degrees
latitude and longitude. The shortest distance (great circle distance)
between pairs of points is desired. First, the spheric coordinates are
translated into Cartesian coordinates. Second, the straight line
distance between points on the unit sphere are calculated. Third,
the great circle distances are computed.


Brooke, A, Kendrick, D, and Meeraus, A, GAMS: A User's Guide. The
Scientific Press, Redwood City, California, 1988.

The center of the earth is the origin for all coordinate systems.

Spheric coordinates   latitude angle  north  positive
                                      south  negative
                      longitude angle east   positive
                                      west   negative

Cartesian coordinates x-axis   0 N   0 E
                      y-axis   0 N  90 E
                      z-axis  90 N

Keywords: great circle distance, orthodromic distance, distance measuring, mathematics
$offText

Set
   k 'coordinates' / x-axis, y-axis, z-axis   /
   a 'airports'    / sfo 'San Francisco'
                     mia 'Miami'
                     jfk 'New York'
                     iah 'Houston'
                     iad 'Washington DC'
                     khi 'Karachi - Pakistan'
                     nnn 'North Pole'
                     sss 'South Pole'         /;

Alias (a,ap);

Table  loc(a,*) 'location on map'
          lat-deg  lat-min  long-deg  long-min
   sfo         37       37      -122       -23
   mia         25       48      - 80       -17
   jfk         40       38      - 73       -47
   iah         29       58      - 95       -20
   iad         38       57      - 77       -25
   khi         24       40        67        10;

Scalar r 'radius of earth (miles)' / 3959 /;

Parameter
   lat(a)     'latitude angle                            (radians)'
   long(a)    'longitude angle                           (radians)'
   uk(a,k)    'point in cartesian coordinates        (unit sphere)'
   useg(a,ap) 'straight line distance between points (unit sphere)'
   udis(a,ap) 'great circle distances                (unit sphere)'
   dis(a,ap)  'great circle distances                      (miles)';

lat (a) = (loc(a,"lat-deg")  + loc(a,"lat-min") /60)*pi/180;
long(a) = (loc(a,"long-deg") + loc(a,"long-min")/60)*pi/180;

uk(a,"x-axis") = cos(long(a))*cos(lat(a));
uk(a,"y-axis") = sin(long(a))*cos(lat(a));
uk(a,"z-axis") =              sin(lat(a));

useg(a,ap) = sqrt(sum(k, sqr(uk(a,k) - uk(ap,k)) ));

//eq1.. TC =e= useg(a,ap);

//Model END / all /;
//solve END using qcp minimizing TC;
//report('minTC') = TC.l;

udis(a,ap) = pi;
udis(a,ap)$(useg(a,ap) < 1.99999) = 2*arctan(useg(a,ap)/2/sqrt(1 - sqr(useg(a,ap)/2)));
dis(a,ap)  = r*udis(a,ap);

option  lat:5, long:5, uk:5, useg:5, udis:5, dis:0;

display loc, lat, long, uk, useg, udis, dis;