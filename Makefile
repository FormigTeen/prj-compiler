compiler:
	flex grammar.l
	gcc -o lexical_analyzer lex.yy.c -lfl

clean:
	rm -f lexical_analyzer lex.yy.c

test: compiler
	./lexical_analyzer < test.money
