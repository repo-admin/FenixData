

CREATE VIEW [dbo].[vwCheckDuplicityCodeVydejky]
AS
/*
Weczerek
31.03.2015

View zobrazuje ve výdejkách ty výdejky, u kterých se vyskytuje jeden materiál ve více řádcích
To má za následek, že se vytvoří 2 resp více stejných řádků v S0, soubor S1 se navrátí správně, ale zobrazení při schvalování S1 je špatné
a i zápis do dodaného zboží u S0 je "nějaký" --> VŽDY JE TĚBA ZKONTROLOVAT !!

*/
SELECT * FROM
(
SELECT COUNT(*) POCET, [MaterialCode],[IdWf]
  FROM [dbo].[VydejkySprWrhMaterials] GROUP BY [MaterialCode],[IdWf]
  ) aa
  WHERE  POCET >1

