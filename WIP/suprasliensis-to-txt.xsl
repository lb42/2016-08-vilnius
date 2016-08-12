<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:template match="line">
        <xsl:if test="concat(@folio,@side) ne preceding-sibling::line[1]/concat(@folio,@side) or not(preceding-sibling::line)">
            <xsl:value-of select="concat(@folio,@side,'&#x0a;')"/>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="subst">
        <xsl:apply-templates select="add"/>
    </xsl:template>
    <xsl:template match="sup">
        <xsl:value-of select="concat('(',.,')')"/>
    </xsl:template>
    <xsl:template match="line/text()">
        <xsl:value-of select="translate(.,'-','')"/>
    </xsl:template>
</xsl:stylesheet>