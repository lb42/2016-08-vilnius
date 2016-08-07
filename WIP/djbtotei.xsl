<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="root">
        <TEI>
            <xsl:apply-templates select="metadata, start"/>
        </TEI>
    </xsl:template>

    <xsl:template match="metadata">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Title</title>
                    <respStmt>
                        <resp>original transcription</resp>
                        <name>
                            <xsl:value-of select="name"/>
                        </name>
                    </respStmt>
                </titleStmt>
                <publicationStmt>
                    <ab>Publication information</ab>
                </publicationStmt>
                <sourceDesc>
                    <ab/>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <charDecl>
                    <glyph xml:id="ooLig">
                        <glyphName>CYRILLIC DOUBLE OMICRON LIGATURE</glyphName>
                    </glyph>
                </charDecl>
            </encodingDesc>
            <revisionDesc>
                <change>Header created by djbtotei</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>

    <xsl:template match="start">
        <text>
            <body>
                <ab>
                    <xsl:apply-templates select="following-sibling::*[following-sibling::end]"/>
                </ab>
            </body>
            <back>
                <ab>
                    <xsl:apply-templates select="following-sibling::*[preceding-sibling::end]"/>
                </ab>
            </back>
        </text>
    </xsl:template>

    <xsl:template match="folio">
        <pb n="{@n}"/>
    </xsl:template>

    <xsl:template match="lacuna">
        <gap extent="{count(line)}" unit="lines"/>
        <!-- the gap is filled with material from another ms -->
        <supplied resp="djb" source="ed">
            <xsl:apply-templates/>
        </supplied>
    </xsl:template>

    <xsl:template match="line">
        <xsl:variable name="hyphenated" as="xs:boolean"
            select="ends-with(preceding-sibling::line[1], '-')"/>
        <xsl:if test="not($hyphenated)">
            <!-- since we can't turn on indentation, detect line breaks where we can wrap to make the output more legible -->
            <xsl:text>&#x0a;</xsl:text>
        </xsl:if>
        <lb>
            <xsl:if test="$hyphenated">
                <xsl:attribute name="break">no</xsl:attribute>
            </xsl:if>
        </lb>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="editionParagraphNo">
        <milestone unit="p" n="{@n}" ed="ed"/>
    </xsl:template>
    <xsl:template match="editionPageNo">
        <pb n="{@n}" ed="ed"/>
    </xsl:template>
    <xsl:template match="sup | lig | red">
        <hi rend="{name()}">
            <xsl:apply-templates/>
        </hi>
        <!-- TODO: add ligatures other than [oo] to <charDecl>; lig should probly be a <g> -->
    </xsl:template>

    <xsl:template match="abbrev">
        <expan>
            <xsl:apply-templates/>
        </expan>
    </xsl:template>

    <!-- assume TEI if anything else -->
    <!-- copy everything else -->

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | comment()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="\[оо\]">
            <!-- Tag input [oo] <hi rend="lig"> containing a <g> -->
            <xsl:matching-substring>
                <hi rend="lig">
                    <g ref="#ooLig">oo</g>
                </hi>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!-- Strip final hyphens and white space -->
                <xsl:value-of select="replace(., '[-\s]+$', '')"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

</xsl:stylesheet>
