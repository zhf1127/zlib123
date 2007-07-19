<?xml version="1.0" encoding="UTF-8"?>
<!--
  * Copyright (c) 2006, Clever Age
  * All rights reserved.
  * 
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *
  *     * Redistributions of source code must retain the above copyright
  *       notice, this list of conditions and the following disclaimer.
  *     * Redistributions in binary form must reproduce the above copyright
  *       notice, this list of conditions and the following disclaimer in the
  *       documentation and/or other materials provided with the distribution.
  *     * Neither the name of Clever Age nor the names of its contributors 
  *       may be used to endorse or promote products derived from this software
  *       without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
  * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
  * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:e="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
    exclude-result-prefixes="e r">


    <!-- We check cell when the picture is starting and ending -->
    <xsl:template name="ValidationCell">
        <xsl:param name="sheet"/>
        <xsl:param name="document"/>

        <xsl:apply-templates select="e:worksheet/e:dataValidations/e:dataValidation[1]">
            <xsl:with-param name="document">
                <xsl:value-of select="$document"/>
            </xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>
































    <xsl:template match="e:dataValidation">
        <xsl:param name="ValidationCell"/>
        <xsl:param name="document"/>

        <xsl:variable name="colNum">
            <xsl:call-template name="GetColNum">
                <xsl:with-param name="cell">
                    <xsl:choose>
                        <xsl:when test="contains(@sqref, ':')">
                            <xsl:value-of select="substring-before(@sqref, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@sqref"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="rowNum">
            <xsl:call-template name="GetRowNum">
                <xsl:with-param name="cell">
                    <xsl:choose>
                        <xsl:when test="contains(@sqref, ':')">
                            <xsl:value-of select="substring-before(@sqref, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@sqref"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="dxfIdStyle">
            <xsl:value-of
                select="count(preceding-sibling::e:dataValidation)"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains(@sqref, ':')">

                <xsl:choose>
                    <xsl:when test="following-sibling::e:dataValidation">
                        <xsl:apply-templates
                            select="following-sibling::e:dataValidation[1]">
                            <xsl:with-param name="ValidationCell">
                                <xsl:call-template name="InsertValidationCell">
                                    <xsl:with-param name="ValidationCell">
                                        <xsl:value-of select="$ValidationCell"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="StartCell">
                                        <xsl:value-of select="substring-before(@sqref, ':')"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="EndCell">
                                        <xsl:value-of select="substring-after(@sqref, ':')"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="document">
                                <xsl:value-of select="$document"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="InsertValidationCell">
                            <xsl:with-param name="ValidationCell">
                                <xsl:value-of select="$ValidationCell"/>
                            </xsl:with-param>
                            <xsl:with-param name="StartCell">
                                <xsl:value-of select="substring-before(@sqref, ':')"/>
                            </xsl:with-param>
                            <xsl:with-param name="EndCell">
                                <xsl:value-of select="substring-after(@sqref, ':')"/>
                            </xsl:with-param>
                            <xsl:with-param name="document">
                                <xsl:value-of select="$document"/>
                            </xsl:with-param>
                            <xsl:with-param name="dxfIdStyle">
                                <xsl:value-of select="$dxfIdStyle"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::e:dataValidation">
                        <xsl:apply-templates
                            select="following-sibling::e:dataValidation[1]">
                            <xsl:with-param name="ValidationCell">
                                <xsl:choose>
                                    <xsl:when test="$document='style'">
                                        <xsl:value-of
                                            select="concat($rowNum, ':', $colNum, ';', '-', $dxfIdStyle, ';', $ValidationCell)"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="concat($rowNum, ':', $colNum, ';', $ValidationCell)"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                            <xsl:with-param name="document">
                                <xsl:value-of select="$document"/>
                            </xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$document='style'">
                                <xsl:value-of
                                    select="concat($rowNum, ':', $colNum, ';', '-', $dxfIdStyle, ';', $ValidationCell)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat($rowNum, ':', $colNum, ';', $ValidationCell)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>









    <xsl:template name="InsertValidationCell">
        <xsl:param name="ValidationCell"/>
        <xsl:param name="StartCell"/>
        <xsl:param name="EndCell"/>
        <xsl:param name="document"/>
        <xsl:param name="dxfIdStyle"/>


        <xsl:variable name="StartColNum">
            <xsl:call-template name="GetColNum">
                <xsl:with-param name="cell">
                    <xsl:value-of select="$StartCell"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="StartRowNum">
            <xsl:call-template name="GetRowNum">
                <xsl:with-param name="cell">
                    <xsl:value-of select="$StartCell"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="EndColNum">
            <xsl:call-template name="GetColNum">
                <xsl:with-param name="cell">
                    <xsl:value-of select="$EndCell"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="EndRowNum">
            <xsl:call-template name="GetRowNum">
                <xsl:with-param name="cell">
                    <xsl:value-of select="$EndCell"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="RepeatRowValidation">
            <xsl:call-template name="RepeatRowValidation">
                <xsl:with-param name="StartColNum">
                    <xsl:value-of select="$StartColNum"/>
                </xsl:with-param>
                <xsl:with-param name="EndColNum">
                    <xsl:value-of select="$EndColNum"/>
                </xsl:with-param>
                <xsl:with-param name="StartRowNum">
                    <xsl:value-of select="$StartRowNum"/>
                </xsl:with-param>
                <xsl:with-param name="EndRowNum">
                    <xsl:value-of select="$EndRowNum"/>
                </xsl:with-param>
                <xsl:with-param name="document">
                    <xsl:value-of select="$document"/>
                </xsl:with-param>
                <xsl:with-param name="dxfIdStyle">
                    <xsl:value-of select="$dxfIdStyle"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="RepeatColValidation">
            <xsl:call-template name="RepeatColValidation">
                <xsl:with-param name="StartColNum">
                    <xsl:value-of select="$StartColNum"/>
                </xsl:with-param>
                <xsl:with-param name="EndColNum">
                    <xsl:value-of select="$EndColNum"/>
                </xsl:with-param>
                <xsl:with-param name="StartRowNum">
                    <xsl:value-of select="$StartRowNum"/>
                </xsl:with-param>
                <xsl:with-param name="EndRowNum">
                    <xsl:value-of select="$EndRowNum"/>
                </xsl:with-param>
                <xsl:with-param name="document">
                    <xsl:value-of select="$document"/>
                </xsl:with-param>
                <xsl:with-param name="dxfIdStyle">
                    <xsl:value-of select="$dxfIdStyle"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="concat($ValidationCell, $RepeatColValidation, $RepeatRowValidation)"/>


    </xsl:template>

    <xsl:template name="RepeatRowValidation">
        <xsl:param name="ValidationCell"/>
        <xsl:param name="StartColNum"/>
        <xsl:param name="StartRowNum"/>
        <xsl:param name="EndColNum"/>
        <xsl:param name="EndRowNum"/>
        <xsl:param name="document"/>
        <xsl:param name="dxfIdStyle"/>

        <xsl:choose>
            <xsl:when test="$StartRowNum != $EndRowNum">
                <xsl:call-template name="RepeatRowValidation">
                    <xsl:with-param name="ValidationCell">
                        <xsl:choose>
                            <xsl:when test="$document='style'">
                                <xsl:value-of
                                    select="concat($StartRowNum, ':', $StartColNum, ';', '-', $dxfIdStyle, ';',$ValidationCell)"
                                /> /> </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat($StartRowNum, ':', $StartColNum, ';', $ValidationCell)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="StartRowNum">
                        <xsl:value-of select="$StartRowNum + 1"/>
                    </xsl:with-param>
                    <xsl:with-param name="StartColNum">
                        <xsl:value-of select="$StartColNum"/>
                    </xsl:with-param>
                    <xsl:with-param name="EndRowNum">
                        <xsl:value-of select="$EndRowNum"/>
                    </xsl:with-param>
                    <xsl:with-param name="EndColNum">
                        <xsl:value-of select="$EndColNum"/>
                    </xsl:with-param>
                    <xsl:with-param name="document">
                        <xsl:value-of select="$document"/>
                    </xsl:with-param>
                    <xsl:with-param name="dxfIdStyle">
                        <xsl:value-of select="$dxfIdStyle"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$document='style'">
                        <xsl:value-of
                            select="concat($StartRowNum, ':', $StartColNum, ';', '-', $dxfIdStyle, ';',$ValidationCell)"
                        /> /> </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat($StartRowNum, ':', $StartColNum, ';', $ValidationCell)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="RepeatColValidation">
        <xsl:param name="ValidationCell"/>
        <xsl:param name="StartColNum"/>
        <xsl:param name="StartRowNum"/>
        <xsl:param name="EndColNum"/>
        <xsl:param name="EndRowNum"/>
        <xsl:param name="document"/>
        <xsl:param name="dxfIdStyle"/>

        <xsl:choose>
            <xsl:when test="$StartColNum != $EndColNum">
                <xsl:call-template name="RepeatRowValidation">
                    <xsl:with-param name="ValidationCell">
                        <xsl:choose>
                            <xsl:when test="$document='style'">
                                <xsl:value-of
                                    select="concat($StartRowNum, ':', $StartColNum, ';', '-', $dxfIdStyle, ';',$ValidationCell)"
                                /> /> </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat($StartRowNum, ':', $StartColNum, ';', $ValidationCell)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="StartRowNum">
                        <xsl:value-of select="$StartRowNum "/>
                    </xsl:with-param>
                    <xsl:with-param name="StartColNum">
                        <xsl:value-of select="$StartColNum + 1"/>
                    </xsl:with-param>
                    <xsl:with-param name="EndRowNum">
                        <xsl:value-of select="$EndRowNum"/>
                    </xsl:with-param>
                    <xsl:with-param name="EndColNum">
                        <xsl:value-of select="$EndColNum"/>
                    </xsl:with-param>
                    <xsl:with-param name="document">
                        <xsl:value-of select="$document"/>
                    </xsl:with-param>
                    <xsl:with-param name="dxfIdStyle">
                        <xsl:value-of select="$dxfIdStyle"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$document='style'">
                        <xsl:value-of
                            select="concat($StartRowNum, ':', $StartColNum, ';', '-', $dxfIdStyle, ';',$ValidationCell)"
                        /> /> </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="concat($StartRowNum, ':', $StartColNum, ';', $ValidationCell)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>













































    <!-- Get Row with Validation-->
    <xsl:template name="ValidationRow">
        <xsl:param name="ValidationCell"/>
        <xsl:param name="Result"/>
        <xsl:choose>
            <xsl:when test="$ValidationCell != ''">
                <xsl:call-template name="ValidationRow">
                    <xsl:with-param name="ValidationCell">
                        <xsl:value-of select="substring-after($ValidationCell, ';')"/>
                    </xsl:with-param>
                    <xsl:with-param name="Result">
                        <xsl:value-of
                            select="concat($Result,  concat(substring-before($ValidationCell, ':'), ';'))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$Result"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="e:sheet" mode="Validation">
        <xsl:param name="number"/>

        <xsl:variable name="Id">
            <xsl:call-template name="GetTarget">
                <xsl:with-param name="id">
                    <xsl:value-of select="@r:id"/>
                </xsl:with-param>
                <xsl:with-param name="document">xl/workbook.xml</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="sheetName">
            <xsl:value-of select="@name"/>
        </xsl:variable>

        <!-- Check If Validations are in this sheet -->

        <xsl:variable name="ValidationCell">
            <xsl:for-each select="document(concat('xl/',$Id))">
                <xsl:call-template name="ValidationCell"/>
            </xsl:for-each>
        </xsl:variable>

        <!--xsl:variable name="ConditionalCellStyle">
                <xsl:for-each select="document(concat('xl/',$Id))">
                    <xsl:call-template name="ConditionalCell">
                        <xsl:with-param name="document">
                            <xsl:text>style</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
                </xsl:variable-->


        <xsl:for-each select="document(concat('xl/',$Id))">

            <xsl:apply-templates select="e:worksheet/e:dataValidations " mode="Validation">
                <xsl:with-param name="sheet">
                    <xsl:value-of select="$Id"/>
                </xsl:with-param>
            </xsl:apply-templates>


            <!--xsl:apply-templates select="e:worksheet/e:sheetData/e:row/e:c" mode="ConditionalAndCellStyle">
                <xsl:with-param name="ConditionalCell">
                    <xsl:value-of select="$ConditionalCell"/>
                </xsl:with-param>
                <xsl:with-param name="ConditionalCellStyle">
                    <xsl:value-of select="$ConditionalCellStyle"/>
                </xsl:with-param>
            </xsl:apply-templates-->

        </xsl:for-each>

        <!-- Insert next Table -->

        <xsl:apply-templates select="following-sibling::e:sheet[1]" mode="Validation">
            <xsl:with-param name="number">
                <xsl:value-of select="$number + 1"/>
            </xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="e:dataValidations" mode="Validation">
        <xsl:call-template name="InsertValidationProperties"/>
    </xsl:template>

    <xsl:template name="InsertValidationProperties">

        <table:content-validations>
            <xsl:call-template name="InsertValidation"/>
        </table:content-validations>
    </xsl:template>

    <!-- Insert Data Validation -->
    <xsl:template name="InsertValidation">
        <xsl:for-each select="e:dataValidation">
            <xsl:sort select="@priority"/>
            <table:content-validation>
                <xsl:attribute name="table:name">
                    <xsl:value-of select=" 'val' "/>
                    <xsl:number/>
                </xsl:attribute>

                <!-- Criteria Data -->
                <xsl:attribute name="table:condition">

                    <xsl:choose>
                        <xsl:when test="contains(@type, 'whole')">
                            <xsl:text>oooc:cell-content-is-whole-number() </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@type, 'decimal')">
                            <xsl:text>oooc:cell-content-is-decimal-number() </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@type, 'date')">
                            <xsl:text>oooc:cell-content-is-is-date() </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@type, 'time')">
                            <xsl:text>oooc:cell-content-is-is-time() </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@type, 'list')">
                            <xsl:text>oooc:cell-content-is-in-list</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@type, 'textLength')">
                            <xsl:text>oooc:cell-content-is-text-length()</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="contains(@operator, 'lessThan')">
                            <xsl:text>and cell-content()&lt;</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@operator, 'lessThanOrEqual')">
                            <xsl:text>and cell-content()&lt;=</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@operator, 'greaterThanOrEqual')">
                            <xsl:text>and cell-content()&gt;=</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@operator, 'greaterThan')">
                            <xsl:text>and cell-content()&gt;</xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(@operator, 'notEqual')">
                            <xsl:text>and cell-content()!=</xsl:text>
                        </xsl:when>
                        <!--xsl:when test="contains(e:formula2, '!=0')">
                            <xsl:text>and cell-content-is-between(</xsl:text>
                        </xsl:when-->
                        <xsl:when test="contains(@operator, 'notBetween')">
                            <xsl:text>and cell-content-is-not-between(</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>and cell-content()=</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:for-each select="e:formula1">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:attribute>

                <!-- Criteria Allow Blank Cells -->
                <xsl:choose>
                    <xsl:when test="contains(@allowBlank, '1')">
                        <xsl:attribute name="table:allow-empty-cell">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>false</xsl:otherwise>
                </xsl:choose>

                <table:help-message>
                    <!-- Input Help - Show input help when cell is selected -->
                    <xsl:choose>
                        <xsl:when test="contains(@showInputMessage, '1')">
                            <xsl:attribute name="table:display">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                    <!-- Input Help Title -->
                    <xsl:attribute name="table:title">
                        <xsl:value-of select="@promptTitle"/>
                    </xsl:attribute>
                    <text:p>
                        <xsl:value-of select="@prompt"/>
                    </text:p>
                </table:help-message>

                <table:error-message>
                    <!-- Error Alert - Show error alert when cell is selected -->
                    <xsl:choose>
                        <xsl:when test="contains(@showErrorMessage, '1')">
                            <xsl:attribute name="table:display">
                                <xsl:text>true</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                    <!-- Error Allert Action-->
                    <xsl:attribute name="table:message-type">
                        <xsl:choose>
                            <xsl:when test="contains(@errorStyle, 'information')">
                                <xsl:text>information</xsl:text>
                            </xsl:when>
                            <xsl:when test="contains(@errorStyle, 'warning')">
                                <xsl:text>warning</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>stop</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <!-- Input Help Title -->
                    <xsl:attribute name="table:title">
                        <xsl:value-of select="@errorTitle"/>
                    </xsl:attribute>
                    <text:p>
                        <xsl:value-of select="@error"/>
                    </text:p>
                </table:error-message>
            </table:content-validation>

        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>