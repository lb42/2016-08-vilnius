<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">

    <xsl:template match="TEI">
        <html>
            <head>
                <title>
                    <xsl:value-of select="//title[@type = 'main']"/>
                </title>
            </head>
            <body>
                <xsl:apply-templates select="//text"/>
            </body>
        </html>
    </xsl:template>
    <!-- Add a template to process <l>, followed by <br/> -->
    <xsl:template match="l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <!-- Process <head> to wrap in HTML <h2> tags -->
    <xsl:template match="head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <!-- 
        Transform each TEI <lg> to number stanzas
        Wrap each TEI <lg> in HTML <p> tags
    -->
    <xsl:template match="lg">
        <h3>
            <xsl:number/>
        </h3>
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="choice/orig"/>
</xsl:stylesheet>
