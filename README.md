<!-- chapter start -->

# PSDataFrame

Microsoft announced the preview of a DataFrame type for .NET to make data exploration easy. https://devblogs.microsoft.com/dotnet/an-introduction-to-dataframe/

The functions n `cvtToDF` is a proof of concept that wraps it in PowerShell so you can easily transform Powershell arrays into a DataFrame and then work with it.

## Test data

|Region|Item|TotalSold|DateSold|Factor|
|---|---|---|---|---|
West|drill|29|12/2|2.1
South|lime|19|12/21|2.1
West|nail|57|12/23|2.1
West|melon|1|12/12|2.1
North|saw|88|12/22|2.1
South|avocado|42|12/24|2.1
North|screws|86|12/25|2.1
West|avocado|7|12/27|2.1
East|avocado|83|12/29|2.1
West|drill|89|12/28|2.1

## PowerShell CSV and DataFrames

```ps
. .\cvtToDF.ps1

(ConvertTo-DataFrame (Import-Csv .\testData.csv)).groupby("Region").Sum("TotalSold").Sort("Region") | Out-DataFrame
```

```
Region TotalSold
------ ---------
East          83
North        174
South         61
West         183
```

## PowerShell Excel and DataFrames

```ps
. .\cvtToDF.ps1

(ConvertTo-DataFrame (Import-Excel .\testData.xlsx)).groupby("Region").Sum("TotalSold").Sort("Region") | Out-DataFrame
```

```
Region TotalSold
------ ---------
East          83
North        174
South         61
West         183
```
<!-- chapter end -->
