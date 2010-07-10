<?xml version="1.0"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
   xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
   xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" 
   xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" 
   xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
   xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
   xmlns:xlink="http://www.w3.org/1999/xlink" 
   xmlns:dc="http://purl.org/dc/elements/1.1/" 
   xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
   xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" 
   xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0" 
   xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
   xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" 
   xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" 
   xmlns:math="http://www.w3.org/1998/Math/MathML"
   xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
   xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
   xmlns:ooo="http://openoffice.org/2004/office" 
   xmlns:ooow="http://openoffice.org/2004/writer"
   xmlns:oooc="http://openoffice.org/2004/calc" 
   xmlns:dom="http://www.w3.org/2001/xml-events"
   xmlns:xforms="http://www.w3.org/2002/xforms"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:rpt="http://openoffice.org/2005/report"
   xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
   xmlns:rdfa="http://docs.oasis-open.org/opendocument/meta/rdfa#" 
   office:version="1.2"
   version="2.0">

  <xsl:output 
     method="text" 
     indent="yes" 
     encoding="utf8" />
  
  <xsl:param name="schema">PLEASE_DEFINE_SCHEMA</xsl:param>
  <!-- quote delimiter : PostgreSQL supports setting the quote delimiters 
       to:  $ANYTHING$ where 'ANYTHING' is any string. -->
  <!-- note that the stylesheet template below adds the heading and 
       trailing '$' marks. -->
  <xsl:param name="delim">PSXML2SQL</xsl:param>

  <xsl:template match="/">
    DROP SCHEMA <xsl:value-of select="$schema"/> CASCADE;
    CREATE SCHEMA <xsl:value-of select="$schema"/>;
    SET search_path = <xsl:value-of select="$schema"/>;

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="table:table[substring(@table:name,2,6) = 'file:/']">
    -- ignoring table with name : <xsl:value-of select="@table:name"/>
  </xsl:template>

  <xsl:template match="table:table">
    <xsl:param name="table"><xsl:value-of select="translate(normalize-space(@table:name),' /.','___')"/></xsl:param>

    <xsl:if test="normalize-space($table) != ''">
      TRUNCATE <xsl:value-of select="$table"/>;

      CREATE TABLE <xsl:value-of select="$table"/> (
    x INTEGER,
    y INTEGER,
    content TEXT,
    style TEXT,
    type TEXT,
    columns_repeated TEXT
    );
    
    <xsl:apply-templates select="table:table-row">
      <xsl:with-param name="table" select="$table"/>
    </xsl:apply-templates>
  </xsl:if>
  
  </xsl:template>

  <xsl:template match="table:table-row">
    <xsl:param name="table"/>
    -- table row : position : <xsl:value-of select="position()"/>.
    <xsl:apply-templates select="table:table-cell">
      <xsl:with-param name="y"><xsl:value-of select="position()"/></xsl:with-param>
      <xsl:with-param name="table" select="$table"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="table:table-cell">
    <xsl:param name="table"/>
    <xsl:param name="y"/>

      INSERT INTO <xsl:value-of select="$table"/> (x,y,content,style,type,columns_repeated) 
    VALUES 
    (
    $_ODS2SQL_$<xsl:value-of select="position()"/>$_ODS2SQL_$,
    $_ODS2SQL_$<xsl:value-of select="$y"/>$_ODS2SQL_$,
    $_ODS2SQL_$<xsl:value-of select="text:p"/>$_ODS2SQL_$,
    $_ODS2SQL_$<xsl:value-of select="@table:style-name"/>$_ODS2SQL_$,
    $_ODS2SQL_$<xsl:value-of select="@office:value-type"/>$_ODS2SQL_$,
    $_ODS2SQL_$<xsl:value-of select="@table:number-columns-repeated"/>$_ODS2SQL_$);


  </xsl:template>

  <xsl:template match="*">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="text()"/>
  
</xsl:stylesheet>

