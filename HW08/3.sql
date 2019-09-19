/*
3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи

CountryId CountryName Code
1 Afghanistan AFG
1 Afghanistan 4
3 Albania ALB
3 Albania 8
*/

SELECT CountryID
      ,CountryName
      ,Code
FROM  (
	SELECT CountryID
          ,CountryName
          ,[IsoAlpha3Code]
          ,CONVERT(NVARCHAR(3),[IsoNumericCode]) AS [IsoNumericCode]
    FROM [Application].[Countries]) p
	UNPIVOT (
		Code FOR CodeType IN ([IsoAlpha3Code],[IsoNumericCode] )
	) unpvt
ORDER BY CountryID