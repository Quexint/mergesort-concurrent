reset
set ylabel 'instructions'
set style fill solid
set title 'Cache-Misses Rate'
set term png enhanced font 'Verdana,10'
set output 'cache-misses.png'
set xtics 0,50000,200000
set xtics rotate by -45
set datafile separator ","

plot 'runtime.txt' using 7:xtic(1) with histogram title 'cache-misses', \
'' using ($0):($7+0.01):7 with labels title ' '
