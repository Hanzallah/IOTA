main: lexIt yaccIt parseIt

parseIt: y.tab.c
	 gcc -o parser y.tab.c

yaccIt:  iota.yacc lex.yy.c
	 yacc iota.yacc

lexIt:   iota.lex
	 lex iota.lex