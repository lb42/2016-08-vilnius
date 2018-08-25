<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:djb="http://www.obdurodon.org" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" version="2.0">
    <!-- djb 2016-08-25 -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:function name="djb:processDate" as="element(event)">
        <!--
            create <event> for birth (cell 7), death (cell 8), and firstMention (cell 9)
            assume that the first string that begins with four digits and contains digits and hyphens is a date
                and create a @when attribute that uses that string as its value
        -->
        <xsl:param name="input" as="xs:string"/>
        <xsl:param name="eventType" as="xs:string"/>
        <event type="{$eventType}">
            <xsl:if test="matches($input, '\d{4}')">
                <xsl:attribute name="when"
                    select="replace($input, '^(.*)(\d{4}[-\d]*)(.*)$', '$2')"/>
            </xsl:if>
            <p>
                <xsl:value-of select="$input"/>
            </p>
        </event>
    </xsl:function>
    <xsl:template match="node() | @*">
        <!-- identity template to copy stuff that we don't need to modify -->
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text">
        <text>
            <body>
                <p>Ignore this: Placeholder text because a complete TEI document must contain more
                    than just a header. Grr.</p>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="sourceDesc">
        <!-- Replace existing <p> content of <sourceDesc> with new <listPerson> -->
        <xsl:copy>
            <listPerson>
                <!-- skip first row, which is the column labels -->
                <xsl:apply-templates select="//row[position() gt 1]"/>
            </listPerson>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="row">
        <!-- 
            create one <person> for each <row> in the input
            convert the input @n value to an output @xml:id
                prefix with 'n' because @xml:id values cannot begin with a digit
                there is no 'n1' because the first row is column labels, but keep the original
                    numbering for easy reference to the Excel spreadsheet
        -->
        <person xml:id="n{normalize-space(@n)}">
            <persName>
                <!--
                    In order: surname, maiden name, forename, middle name, honorific, suffix
                -->
                <xsl:apply-templates select="cell[position() eq 1]"/>
                <xsl:apply-templates select="cell[position() eq 4]"/>
                <xsl:apply-templates select="cell[position() eq 2]"/>
                <xsl:apply-templates select="cell[position() eq 3]"/>
                <xsl:apply-templates select="cell[position() eq 5]"/>
                <xsl:apply-templates select="cell[position() eq 6]"/>
            </persName>
            <xsl:apply-templates select="cell[position() gt 6 and position() ne 11]"/>
        </person>
    </xsl:template>
    <xsl:template match="cell[position() lt 7 or position() gt 9]">
        <xsl:variable name="normalized" select="normalize-space(.)" as="xs:string"/>
        <xsl:variable name="position" select="count(preceding-sibling::cell) + 1" as="xs:integer"/>
        <xsl:message><xsl:value-of select="$position"/></xsl:message>
        <xsl:if test="string-length($normalized) gt 0">
            <xsl:choose>
                <xsl:when test="$position eq 1">
                    <surname>
                        <xsl:value-of select="$normalized"/>
                    </surname>
                </xsl:when>
                <xsl:when test="$position eq 4">
                    <surname type="maiden">
                        <xsl:value-of select="$normalized"/>
                    </surname>
                </xsl:when>
                <xsl:when test="$position eq 2">
                    <forename>
                        <xsl:value-of select="$normalized"/>
                    </forename>
                </xsl:when>
                <xsl:when test="$position eq 3">
                    <forename type="middle">
                        <xsl:value-of select="$normalized"/>
                    </forename>
                </xsl:when>
                <xsl:when test="$position eq 5">
                    <roleName type="honorific">
                        <xsl:value-of select="$normalized"/>
                    </roleName>
                </xsl:when>
                <xsl:when test="$position eq 6">
                    <genName>
                        <xsl:value-of select="$normalized"/>
                    </genName>
                </xsl:when>
                <xsl:when test="$position eq 10">
                    <resp>
                        <org>
                            <xsl:value-of select="$normalized"/>
                        </org>
                    </resp>
                </xsl:when>
                <xsl:when test="$position eq 12">
                    <note>
                        <p>
                            <xsl:value-of select="$normalized"/>
                        </p>
                    </note>
                </xsl:when>

            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="cell[position() gt 6 and position() lt 10]">
        <xsl:variable name="normalized" select="normalize-space(.)" as="xs:string"/>
        <xsl:variable name="position" select="count(preceding-sibling::cell) + 1" as="xs:integer"/>
        <xsl:if test="string-length($normalized) gt 0">
            <xsl:choose>
                <xsl:when test="$position eq 7">
                    <xsl:sequence select="djb:processDate($normalized, 'birth')"/>
                </xsl:when>
                <xsl:when test="$position eq 8">
                    <xsl:sequence select="djb:processDate($normalized, 'death')"/>
                </xsl:when>
                <xsl:when test="$position eq 9">
                    <xsl:sequence select="djb:processDate($normalized, 'firstMention')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
