reset
set ylabel 'time(ns)'
set style fill solid
set title 'Running Time'
set term png enhanced font 'Verdana,10'
set output 'runtime.png'
set xtics 0,50000,200000
set xtics rotate by -45
set datafile separator ","

plot 'runtime.txt' using 5:xtic(1) with histogram title 'time', \
'' using ($0):($5+0.01):5 with labels title ' '
