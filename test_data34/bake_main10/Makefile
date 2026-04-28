all : main_prog

clean : 
	rm -f  main_prog func_01.o func_02.o func_03.o func_04.o func_05.o func_06.o func_07.o func_08.o func_09.o func_10.o 

main_func.o : main_func.c
	gcc -c main_func.c

func_01.o : func_01.c
	gcc -c func_01.c

func_02.o : func_02.c
	gcc -c func_02.c

func_03.o : func_03.c
	gcc -c func_03.c

func_04.o : func_04.c
	gcc -c func_04.c

func_05.o : func_05.c
	gcc -c func_05.c

func_06.o : func_06.c
	gcc -c func_06.c

func_07.o : func_07.c
	gcc -c func_07.c

func_08.o : func_08.c
	gcc -c func_08.c

func_09.o : func_09.c
	gcc -c func_09.c

func_10.o : func_10.c
	gcc -c func_10.c

main_prog : main_func.o func_01.o func_02.o func_03.o func_04.o func_05.o func_06.o func_07.o func_08.o func_09.o func_10.o 
	gcc -o main_prog main_func.o func_01.o func_02.o func_03.o func_04.o func_05.o func_06.o func_07.o func_08.o func_09.o func_10.o 
