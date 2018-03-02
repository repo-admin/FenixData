


CREATE VIEW [dbo].[OdberatelPomoc]
AS


SELECT    id,
          [CisloOrg]
           ,[Nazev]
           ,[Misto]
           ,[Ulice]
           --,null
           --,null
           ,[PSC]
           --,[PoBox]
           --,null
           --,null
           --,null
           ,[DIC]
           ,[ICO]
           --,[LhutaSplatnosti]
           --,[JeDodavatel]
           --,[JeOdberatel]
           ,idZeme
            ,[Popis-Jméno - telefon]
            --,cis1.[Typ_kontaktu]
            ,Telefon
           ,[Popis-Jméno - Mail]
            --,cis2.[Typ_kontaktu]
            , Mail

           --,null
           --,1         -- [IS_ACTIVE]
           --,GETDATE() -- [EDIT_DATE]
           --,12        -- [EDIT_ID_USER]
FROM [dbo].[OdberateleHeliosPomoc]
  --FROM [Ciselniky].[dbo].[vwOrganizace]    vw
  --LEFT OUTER JOIN (SELECT * FROM [Ciselniky].[dbo].[vwHelKontakty] WHERE [Typ_kontaktu]='Pevná') cis1
  --ON vw.CisloOrg=cis1.CisloOrg
  --LEFT OUTER JOIN (SELECT * FROM [Ciselniky].[dbo].[vwHelKontakty] WHERE [Typ_kontaktu]='Email') cis2
  --ON vw.CisloOrg=cis2.CisloOrg
  --WHERE [JeDodavatel]=1

  --SELECT count(*) FROM [Ciselniky].[dbo].[vwOrganizace]    vw
  --LEFT OUTER JOIN (SELECT * FROM [Ciselniky].[dbo].[vwHelKontakty] WHERE [Typ_kontaktu]='Pevná') cis1
  --ON vw.CisloOrg=cis1.CisloOrg
  --LEFT OUTER JOIN (SELECT * FROM [Ciselniky].[dbo].[vwHelKontakty] WHERE [Typ_kontaktu]='Email') cis2
  --ON vw.CisloOrg=cis2.CisloOrg
  --WHERE [JeDodavatel]=1











