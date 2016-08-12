<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:template match="root">
        <xsl:apply-templates select="//folio | //line[preceding::start and following::end]"/>
    </xsl:template>
    <xsl:template match="line">
        <xsl:value-of select="concat(translate(.,'-*[]', ''), '&#x0a;')"/>
    </xsl:template>
    <xsl:template match="sup">
        <xsl:value-of select="concat('(',.,')')"/>
    </xsl:template>
    <xsl:template match="folio">
        <xsl:value-of select="concat(@n, '&#x0a;')"/>
    </xsl:template>
</xsl:stylesheet>