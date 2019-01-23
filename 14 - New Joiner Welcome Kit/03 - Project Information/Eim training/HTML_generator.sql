
set nocount on

 
DECLARE @EIM_TABLE nvarchar(100)

set @EIM_TABLE='EIM_ACCOUNT'

 

SELECT '<html><body>'
SELECT '<table border=1>'
SELECT '<tr><td> <b><h3>',@EIM_TABLE,'</h3></b></td><td></tr>'
SELECT '<tr><td> <b>Sheet Generated on: </td><td>', DATEPART (d,getdate()),'/', DATEPART (mm,getdate()),'/', DATEPART (yyyy,getdate())
SELECT '</b></td></tr>'
SELECT '<TR>
            <TD><b>Destination Table</b></TD>
            <TD><b>Destination Column</b></TD>
            <TD><b>UK</b></TD>
            <TD><b>Req</b></TD>
            <TD><b>DType</b></TD>'
select '
            <TD><b>DValue</b></TD>
            <TD><b>Destination Description</b></TD>
            <TD><b>Source Column</b></TD>
            <TD><b>Data Type</b></TD>
            <TD><b>Len</b></TD>
            <TD><b>PC Intersect Table</b></TD>
            </TR>'
SELECT      
      '<tr><td>',       "Destination Table",                            '</td>',
      '<td>',           "Destination Column",                           '</td>',
      '<td>',
                  CASE "UK1" 
                        WHEN 'x' 
                  THEN '' 
                  ELSE "UK1"
                  END "UK",                                 '</td>',
      '<td>',     "Req",                                          '</td>',
      '<td>',           ISNULL("DType", '.') DType,                     '</td>',
      '<td>',           ISNULL("DValue", '.') DValue,                         '</td>',
      '<td>', LEFT("Destination Description", 45)"Destination Description",   '</td>',
      '<td>',     "Source Column",                                '</td>',
      '<td>',CASE "Data Type"
            WHEN 'C' THEN 'Char'
            WHEN 'D' THEN 'Date'
            WHEN 'N' THEN 'Number'
            WHEN 'S' THEN 'DateTime'
            WHEN 'T' THEN 'Time'
            WHEN 'U' THEN 'UTC DateT'
            WHEN 'V' THEN 'Varchar'
            WHEN 'X' THEN 'Text'
      END "Data Type", '</td>',
      '<td>',"Len",'</td>', 
      '<td>',"PC Intersect Table"'</td></tr>' --INTO TEST_EIM_MAP*/
 

FROM 
 

(
      SELECT
            CASE BT.ROW_ID
                  WHEN IT.TARGET_TBL_ID THEN '*'
      ELSE ''
      END + 
      BT.NAME "Destination Table", 
      BC.NAME "Destination Column",
            CASE 
                  WHEN BC.USR_KEY_SEQUENCE IS NULL THEN 'x'
            ELSE STR(BC.USR_KEY_SEQUENCE) END "UK1", BC.REQUIRED "Req",
            CASE WHEN BC.LOV_TYPE_CD IS NULL THEN NULL
            ELSE
             CASE BC.LOV_BOUNDED
            WHEN 'N' THEN 'LOV'
            ELSE CASE WHEN BC.TRANS_TABLE_ID IS NULL THEN 'LOVB'
             ELSE 'MLOV'
            END END END "DType",
            BC.LOV_TYPE_CD "DValue",
            BC.USER_NAME "Destination Description",
            IC.NAME "Source Column", 
            IC.DATA_TYPE "Data Type", 
            IC.LENGTH "Len", NULL "PC Intersect Table"
            FROM S_COLUMN IC, S_COLUMN BC, S_EIM_ATT_MAP MA,
            S_TABLE BT, S_EIM_TBL_MAP MT, S_TABLE IT, S_REPOSITORY R
            WHERE 
            MA.IFTAB_DATA_COL_ID = IC.ROW_ID
            AND MA.BTAB_ATT_COL_ID = BC.ROW_ID
            AND MA.INACTIVE_FLG = 'N'
            AND MT.ROW_ID = MA.EIM_TBL_MAP_ID
            AND MT.DEST_TBL_ID = BT.ROW_ID
            AND MT.INACTIVE_FLG = 'N'
            AND IT.ROW_ID = MT.IF_TBL_ID
            AND IT.NAME = @EIM_TABLE
            AND R.ROW_ID = IT.REPOSITORY_ID
            AND R.NAME = 'Siebel Repository'
 

      UNION
            SELECT CASE BT.ROW_ID
             WHEN IT.TARGET_TBL_ID THEN '*'
             ELSE ''
            END + BT.NAME "Destination Table", BC.NAME "Destination Column",
            CASE WHEN BC.USR_KEY_SEQUENCE IS NULL THEN 'x'
             ELSE STR(BC.USR_KEY_SEQUENCE) END "UK1", BC.REQUIRED "Req",
            'PC' "DType", FT.NAME "DValue",
            BC.USER_NAME "Destination Description",
            IC.NAME "Source Column", 
            IC.DATA_TYPE "Data Type", 
            IC.LENGTH "Len", ITS.NAME "PC Intersect Table"
            FROM S_COLUMN IC, S_TABLE BT, S_TABLE FT, S_COLUMN BC, 
            S_EIM_EXPPR_MAP ME, S_TABLE ITS, 
            S_EIM_TBL_MAP MT, S_TABLE IT, S_REPOSITORY R
            WHERE 
            ME.IFTAB_PRFLG_COL_ID = IC.ROW_ID
            AND BC.TBL_ID = BT.ROW_ID
            AND BC.FKEY_TBL_ID = FT.ROW_ID
            AND ME.BTAB_PC_COL_ID = BC.ROW_ID
            AND ME.INACTIVE_FLG = 'N'
            AND MT.ROW_ID = ME.EIM_TBL_MAP_ID
            AND MT.DEST_TBL_ID = ITS.ROW_ID
            AND MT.INACTIVE_FLG = 'N'
            AND IT.ROW_ID = MT.IF_TBL_ID
            AND IT.NAME =@EIM_TABLE
            AND R.ROW_ID = IT.REPOSITORY_ID
            AND R.NAME = 'Siebel Repository'
      UNION
            SELECT CASE BT.ROW_ID
             WHEN IT.TARGET_TBL_ID THEN '*'
             ELSE ''
            END + BT.NAME "Destination Table", BC.NAME "Destination Column",
            CASE WHEN BC.USR_KEY_SEQUENCE IS NULL THEN 'x'
             ELSE STR(BC.USR_KEY_SEQUENCE) END "UK1", BC.REQUIRED "Req",
            'FK' "DType", FT.NAME "DValue",
            BC.USER_NAME "Destination Description",
            IC.NAME "Source Column", 
            IC.DATA_TYPE "Data Type", 
            IC.LENGTH "Len", NULL "PC Intersect Table"
            FROM S_COLUMN IC, S_TABLE FT, S_COLUMN BC, 
            S_EIM_FK_MAPCOL MFC, S_EIM_FK_MAP MF,
            S_TABLE BT, S_EIM_TBL_MAP MT, S_TABLE IT, S_REPOSITORY R
            WHERE 
            MFC.IFTAB_COL_ID = IC.ROW_ID
            AND BC.FKEY_TBL_ID = FT.ROW_ID
            AND MF.FK_COL_ID = BC.ROW_ID
            AND MFC.INACTIVE_FLG = 'N'
            AND MF.ROW_ID = MFC.EIM_FK_MAP_ID
            AND MF.INACTIVE_FLG = 'N'
            AND MT.ROW_ID = MF.EIM_TBL_MAP_ID
            AND MT.DEST_TBL_ID = BT.ROW_ID
            AND MT.INACTIVE_FLG = 'N'
            AND IT.ROW_ID = MT.IF_TBL_ID
            AND IT.NAME =@EIM_TABLE
            AND R.ROW_ID = IT.REPOSITORY_ID
            AND R.NAME = 'Siebel Repository') AS MAPPING
            ORDER BY "Destination Table", "UK1", "Req" DESC, "Destination Column", "Source Column"
SELECT '</table></body></html>'

