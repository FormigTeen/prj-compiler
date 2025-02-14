compiler: parser
	flex grammar.l
	gcc -o lexical_analyzer lex.yy.c grammar.tab.c -lfl

parser:
	bison -d grammar.y
	gcc -c grammar.tab.c

clean:
	rm -f lexical_analyzer lex.yy.c grammar.tab.c grammar.tab.h

test: compiler
	./lexical_analyzer < test.money
