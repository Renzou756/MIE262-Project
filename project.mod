set I;      									  #Index of shoe type
set J;        									  #Index of machine
set K;   	  									  #Index of raw material
set W;    										  #Index of warehouse
set Year := {1997,1998,1999,2000,2001,2002,2003};
set Store := {1,2,3,4,5,6,7,8,9,10};

param t{I,J} default 0;        															#Time in seconds it takes for machine j to produce shoe i  xxx
param s{I};                  															#Sale price of shoe i                                      xxx
param C{W};                			    												#Capacity of warehouse w                                   xxx
param p{W};                  															#Cost of opening warehouse w                               xxx
param d{I,Year,Store};                   												#Demand for shoe i in year e in month m in store s         xxx
param c{K};                  															#Cost of each raw material k                               xxx
param a{I,K} default 0;         												        #Amount of the kth raw material for shoe i                 xxx
param D{i in I} := sum{year in Year, store in Store} 2*d[i,year,store]*(1/7);       	#Demand for shoe i                                         xxx
param H{j in J};																		#Cost in dollars per minute of operating machine j
param A{k in K};																		#Amount available for purchase of material k

var x{I,W} >= 0;       #Amount of pairs of shoe i stored in warehouse w
var y{W} binary;               #State of warehouse w (1 if open, 0 if closed)
 
maximize profit :

(sum{i in I, w in W} s[i]*x[i,w])   			                    #revenue
- 25*(sum{j in J, i in I, w in W} t[i,j]*x[i,w]*(1/3600))           #workers cost
- (sum{k in K, i in I, w in W} c[k]*a[i,k]*x[i,w])                  #raw material cost
- (sum{i in I} 10 *(D[i]-(sum{w in W}x[i,w])) )                   #demand cost
- (sum{w in W} y[w]*p[w])                                           #warehouse cost
- (sum{j in J} H[j]*(sum{i in I, w in W}t[i,j]*x[i,w]*(1/60)));      #operating cost                  

s.t. co1 {w in W}: sum{i in I} x[i,w] <= C[w]*y[w];	                       #Warehouse capacity constraint
s.t. co2 {i in I}: sum{w in W} x[i,w] <= D[i]; 				               #Demand constraint
s.t. co3 {j in J}: sum{i in I, w in W} t[i,j]*x[i,w] <= 1209600;		   #Machine time constraint in seconds
s.t. co4 : sum{i in I, k in K, w in W} c[k]*a[i,k]*x[i,w] <= 10000000;     #Budget constraint
s.t. co5 {k in K}: sum{i in I, w in W} a[i,k]*x[i,w] <= A[k];			   #Raw material available constraint
