.PHONY: all clean 

all: spreadsheet.sql

spreadsheet.sql: content.xml
	saxonb-xslt -xsl:ods2sql.xsl -s:content.xml schema=gas > $@

content.xml:
	unzip gasprices.ods

pswrgwall.xls: 
	wget http://tonto.eia.doe.gov/oog/ftparea/wogirs/xls/pswrgvwall.xls

clean:
	-rm -rf mimetype Configurations2 styles.xml meta.xml \
		Thumbnails settings.xml META-INF \
		 content.xml spreadsheet.sql \
		 pswrgwall.xls


