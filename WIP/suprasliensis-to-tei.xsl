<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="text">
        <xsl:text>&#x0a;</xsl:text>
        <TEI>
            <teiHeader xml:space="preserve">
                <fileDesc>
                    <titleStmt>
                        <title>Vita of Paul the Simple from the Codex Suprasliensis</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Unpublished</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>http://suprasliensis.obdurodon.org</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <xsl:text>&#x0a;</xsl:text>
            <text>
                <xsl:text>&#x0a;</xsl:text>
                <body>
                    <xsl:text>&#x0a;</xsl:text>
                    <ab>
                        <xsl:apply-templates select="line"/>
                    </ab>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="line">
        <xsl:if
            test="concat(@folio, @side) ne preceding-sibling::line[1]/concat(@folio, @side) or not(preceding-sibling::line)">
            <xsl:text>&#x0a;</xsl:text>
            <pb n="{concat(@folio, @side)}"/>
        </xsl:if>
        <xsl:text>&#x0a;</xsl:text>
        <lb n="{@line}">
            <xsl:if test="ends-with(preceding-sibling::line[1], '-')">
                <xsl:attribute name="break" select="'no'"/>
            </xsl:if>
        </lb>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="del | add | subst">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="line/text()">
        <xsl:value-of select="translate(., '-', '')"/>
    </xsl:template>
    <xsl:template match="sup">
        <hi rend="sup">
            <xsl:apply-templates/>
        </hi>
    </xsl:template>
</xsl:stylesheet>
