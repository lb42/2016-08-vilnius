<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="latin_one-to-one" as="xs:string"
        >abvgdežziklmnoprstfcčš"y'ěABVGDEŽZIKLMNOPRSTFCČŠYĚ</xsl:variable>
    <xsl:variable name="cyrillic_one-to-one" as="xs:string"
        >абвгдежзиклмнопрстфцчшъыьѣАБВГДЕЖЗИКЛМНОПРСТФЦЧШЫѢ</xsl:variable>
    <xsl:function name="djb:remap" as="xs:string">
        <xsl:param name="input" as="xs:string"/>
        <xsl:param name="pair" as="xs:integer"/>
        <xsl:variable name="in" select="$many-to-one[$pair]/in" as="xs:string?"/>
        <xsl:variable name="out" select="$many-to-one[$pair]/out" as="xs:string?"/>
        <xsl:value-of
            select="
                if ($pair gt count($many-to-one)) then
                    translate($input, $latin_one-to-one, $cyrillic_one-to-one)
                else
                    djb:remap(replace($input, $in, $out), $pair + 1)"
        />
    </xsl:function>
    <xsl:variable name="many-to-one" as="element(mapping)+">
        <mapping>
            <in>ja</in>
            <out>ꙗ</out>
        </mapping>
        <mapping>
            <in>ju</in>
            <out>ю</out>
        </mapping>
        <mapping>
            <in>ch</in>
            <out>х</out>
        </mapping>
        <mapping>
            <in>u</in>
            <out>оу</out>
        </mapping>
    </xsl:variable>
    <xsl:template match="stuff">
        <xsl:copy>
            <latin>
                <xsl:copy-of select="*"/>
            </latin>
            <cyrillic>
                <xsl:apply-templates/>
            </cyrillic>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="* | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="djb:remap(., 1)"/>
    </xsl:template>
</xsl:stylesheet>
