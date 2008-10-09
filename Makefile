APP=mandeldraw
VERSION=1.1
PACKAGE=$(APP)-$(VERSION)
TARWILD=$(APP)-*.tar.gz
TARFILE=$(PACKAGE).tar.gz
COMPILER=ocamlopt.opt

mandeldraw: mandeldraw.ml mandelbrot.cmx
	$(COMPILER) -o mandeldraw graphics.cmxa mandelbrot.cmx mandeldraw.ml

mandelbrot.cmx: mandelbrot.ml
	$(COMPILER) -c mandelbrot.ml

run: mandeldraw
	./mandeldraw

cleanish:
	rm -f *~ *.cm{o,i,x} *.o

clean: cleanish
	rm -f mandeldraw $(TARWILD)

package: 
	rm -f $(TARWILD)
	mkdir $(PACKAGE)
	cp README Makefile COPYING *.ml $(PACKAGE)
	tar czvf $(TARFILE) $(PACKAGE)
	rm -f $(PACKAGE)/*
	rmdir $(PACKAGE)
