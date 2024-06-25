   --------------------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-actual] --------------------------- 
        DELETE A
        FROM [PowerBI].[pfy-dss-pbi-actual] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.FinancialYear = PF.FinancialYear
        WHERE PF.CurrentYear = 1
   --------------------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-contractinformation] --------------------------- 
    
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-contractinformation] A 
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.[Fiscal Year] = PF.FinancialYear
        WHERE PF.CurrentYear = 1
   --------------------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-customercount] --------------------------- 
   
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-customercount] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
    WHERE PF.CurrentYear = 1
            
    --------------------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] --------------------------- 
    
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
    WHERE PF.CurrentYear = 1

   --------------------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-outcome] --------------------------- 
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-outcome] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
    WHERE PF.CurrentYear = 1

    ---------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-outcome-actualvolume] --------------
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-outcome-actualvolume] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
    WHERE PF.CurrentYear = 1
 
    ---------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-outcomeactualfact] --------------
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-outcomeactualfact] A
    INNER JOIN [PowerBI].[v-dss-pbi-date] PF ON A.Date = PF.Date
    WHERE PF.CurrentYear = 1

    ---------- REMOVE CFY DATA FROM [PowerBI].[pfy-dss-pbi-conversionrate] --------------
    DELETE A
    FROM [PowerBI].[pfy-dss-pbi-conversionrate] A
    INNER JOIN [PowerBI].[v-dss-pbi-date] PF ON A.Date = PF.Date
    WHERE PF.CurrentYear = 1