Src=main#
Bib=$(shell ls *.bib *.bst)#
D=$(HOME)/tmp/$(Src)#
define grab
   gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=$(1) -dLastPage=$(2) \
       -sOutputFile=$@ $<
endef

all: dirs tex bib  tex tex tex     done

typo:
	- git status
	- git commit -am "typo"
	- git push origin master

commit:
	- git status
	- git commit -a
	- git push origin master

update:
	- git pull origin master

status:
	- git status

one: dirs tex done 

open:
	open $(D).pdf

evince:
	evince $(D).pdf 2> /dev/null &


skim:
	/Applications/Skim.app/Contents/MacOS/Skim $(D).pdf &


view:
	evince $(D).pdf &

abe :  $(D)_a.pdf $(D)_b.pdf $(D)_e.pdf

$(D).pdf : $(Src).tex $(Bib)
	pdflatex -output-directory=$(HOME)/tmp $(Src)

$(D)_a.pdf : $(D).pdf; $(call grab,1,1)		
$(D)_b.pdf : $(D).pdf; $(call grab,2,16)		
$(D)_e.pdf : $(D).pdf; $(call grab,18,28)		

done: embedfonts  
	@printf "\n\n\n==============================================\n"
	@printf       "see output in $(D).pdf\n"
	@printf       "==============================================\n\n\n"
	@printf "\n\nWarnings (may be none):\n\n"
	grep arning $D.log

dirs: 
	- [ ! -d $(HOME)/tmp ] && mkdir $(HOME)/tmp

tex: files $(D).pdf

files:
	cp *.tex $(HOME)/tmp

embedfonts:
	@ gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite \
          -sOutputFile=$(D)-embedded.pdf $(D).pdf
	@ mv  $(D)-embedded.pdf $(D).pdf

bib:
	echo $(Bib)
	- cp $(Bib) $(HOME)/tmp; cd $(HOME)/tmp; bibtex $(Src)
clean:
	rm $D.*
