cd Bdinski
for f in *.xml; do echo $f; saxon -o:TEI/$f $f ../djbtotei.xsl;\
jing -c ../teiObd.rnc TEI/$f; done 
