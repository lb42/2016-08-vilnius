ECHO=

PROFILES=/home/lou/Public/Stylesheets/profiles
PROFILE=teiOCS

TALKS= \
	talk-tei \
	talk-tools \
	talk-transcription

EXERCISES= \
	ex-msdesc \
	ex-xslt

default: pdfslides exercises

exercises:
	for i in $(EXERCISES) ; do \
		teitopdf --profile=$(PROFILE) --profiledir=$(PROFILES) $$i.xml; \
	mv $$i.xml.pdf ../Work/$$i.pdf; \
	done

slides: pdfslides 

pdfslides:  
	for i in $(TALKS) ; do \
		teitoslides --profile=teiOCS $$i.xml ;\
	mv $$i.xml.slides  ../Slides/$$i.pdf; \
	done


clean:
	-rm -f *.aux
	-rm -f *.log
	-rm -f *.nav
	-rm -f *.out
	-rm -f *.snm
	-rm -f *.tex
	-rm -f *.toc
	-rm -f *.vrb
	-rm -f *.eps *.dvi
	-rm -f *.xhtml
	-rm -f *~

all:
	xmllint --xinclude talks.xml > diapos.xml
	teitoepub --profile=tei --odd diapos.xml
	teitodocx --profile=tei diapos.xml
	rm -f travaux.zip
	zip -r travaux `find Travaux -type f | grep -v .svn`

handout: 
	cat booklet-top.txt > booklet-xi.xml
	echo '<?tex \\newpage ?>' >> booklet-xi.xml
	for i in $(EXERCISES); do \
		echo "<div>" >> booklet-xi.xml; \
		grep "<title>" $$i.xml | head -1 | sed 's/title>/head>/g' >> booklet-xi.xml; \
		echo "<xi:include href=\"$$i.xml#xmlns(t=http://www.tei-c.org/ns/1.0)xpointer(/t:TEI/t:text/t:body/t:*)\"/>" >> booklet-xi.xml; \
		echo "</div>" >> booklet-xi.xml; \
		echo '<?tex \\newpage ?>'>> booklet-xi.xml ; \
	done
	echo '<?tex \\newpage ?>'>> booklet-xi.xml
	cat booklet-end.txt >> booklet-xi.xml
	xmllint --xinclude booklet-xi.xml > booklet.xml
	saxon booklet.xml booklet.xsl > booklet.tex
	perl -p -i -e 's+.color{red}++g' booklet.tex
	echo perl -p -i -e 's+\\maketitle++g' booklet.tex
	pdflatex booklet
	pdflatex booklet
	pdflatex booklet
	mv booklet.pdf exercices.pdf

validate:
	-for i in $(TALKS) ; do onvdl ../teitalks.nvdl `basename $$i .xml`.xml \
	 | grep -v ': error: unfinished element$$' \
	 | grep -v ': error: unfinished element .* required to finish the element$$'; done

demo:
	xmllint --xinclude demo.odd > x.odd; roma2 --docpdf --nodtd --dochtml --isoschematron x.odd .
	roma --nodtd --noxsd --schema=demosimple x.odd .
	saxon demo.isosch http://www.tei-c.org/release/xml/tei/odd/Utilities/iso_schematron_message_xslt2.xsl > demo.isosch.xsl

test:
	jing demo.rng demo.xml
	rnv demo.rnc demo.xml
	saxon demo.xml demo.isosch.xsl 
	jing demo.xsd demo.xml


