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
        <xsl:variable name="normalizedInput" select="normalize-space($input)" as="xs:string"/>
        <event type="{$eventType}">
            <xsl:if test="matches($normalizedInput, '\d{4}')">
                <xsl:attribute name="when"
                    select="replace($normalizedInput, '^(.*)(\d{4}[-\d]*)(.*)$', '$2')"/>
            </xsl:if>
            <p>
                <xsl:value-of select="$normalizedInput"/>
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
                    create surname (principal and maiden), forenames (principal and middle), title, and suffix
                        only if they exist in the input
                    normalize space in case some cells contain just stray white space
                -->
                <xsl:if test="string-length(normalize-space(cell[1])) gt 0">
                    <surname>
                        <xsl:value-of select="normalize-space(cell[1])"/>
                    </surname>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(cell[4])) gt 0">
                    <surname type="maiden">
                        <xsl:value-of select="normalize-space(cell[4])"/>
                    </surname>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(cell[2])) gt 0">
                    <forename>
                        <xsl:value-of select="normalize-space(cell[2])"/>
                    </forename>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(cell[3])) gt 0">
                    <forename type="middle">
                        <xsl:value-of select="normalize-space(cell[3])"/>
                    </forename>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(cell[5])) gt 0">
                    <roleName type="honorific">
                        <xsl:value-of select="normalize-space(cell[5])"/>
                    </roleName>
                </xsl:if>
                <xsl:if test="string-length(normalize-space(cell[6])) gt 0">
                    <genName>
                        <xsl:value-of select="normalize-space(cell[6])"/>
                    </genName>
                </xsl:if>
            </persName>
            <!--
                birth, death, and first mention are processed with a function, since they use the same code
                pass in the value
            -->
            <xsl:if test="string-length(normalize-space(cell[7])) gt 0">
                <xsl:sequence select="djb:processDate(cell[7], 'birth')"/>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(cell[8])) gt 0">
                <xsl:sequence select="djb:processDate(cell[8], 'death')"/>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(cell[9])) gt 0">
                <xsl:sequence select="djb:processDate(cell[9], 'firstMention')"/>
            </xsl:if>
            <xsl:if test="string-length(normalize-space(cell[10])) gt 0">
                <!--
                    assume that the responsible body is an <org>; this assumption may be erroneous
                -->
                <resp>
                    <org>
                        <xsl:value-of select="normalize-space(cell[10])"/>
                    </org>
                </resp>
            </xsl:if>
            <!-- skip cell 11 (xml:id) because there are no values in the spreadsheet -->
            <xsl:if test="string-length(normalize-space(cell[12])) gt 0">
                <note>
                    <p>
                        <xsl:value-of select="normalize-space(cell[12])"/>
                    </p>
                </note>
            </xsl:if>
        </person>
    </xsl:template>
</xsl:stylesheet>
