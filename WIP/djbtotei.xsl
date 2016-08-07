<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output indent="yes"/>
    <!-- Specify the TEI default output namespace as an @xmlns attribute on <xsl:stylesheet>, not as @xpath-default-namespace on <xsl:output> -->

    <xsl:template match="/">
        <xsl:apply-templates select="//root"/>
    </xsl:template>

    <xsl:template match="root">
        <TEI>
            <xsl:apply-templates select="metadata"/>
            <xsl:apply-templates select="start"/>

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
            <revisionDesc>
                <change>Header created by djbtotei</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>

    <xsl:template match="start">
        <text>
            <body>
                <ab>
                    <xsl:apply-templates select="following-sibling::*[not(name() = 'end')]"/>
                </ab>
            </body>
            <back>
                <xsl:apply-templates select="//end"/>
            </back>
        </text>
    </xsl:template>

    <xsl:template match="end">
        <ab>
            <xsl:apply-templates select="following-sibling::*"/>
        </ab>
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
        <lb/>
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
        <!-- lig should probly be a g -->
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
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@* | text()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="comment()">
        <xsl:copy/>
    </xsl:template>



</xsl:stylesheet>
