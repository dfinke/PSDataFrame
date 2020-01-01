<!-- chapter start -->

[An Introduction to DataFrame](https://devblogs.microsoft.com/dotnet/an-introduction-to-dataframe/)

> Microsoft is announcing the preview of a DataFrame type for .NET to make data exploration easy

The functions in the PowerShell `cvtToDF` is a proof of concept allowing you to easily transform Powershell arrays into a DataFrame and then explore.

There are a couple of other functions `Out-DataFrame` which formats it to more PowerShell readable output and `Add-ToDF` that lets you manipulate data in a column.

## Test data

Here is the sample data, save in both a `csv` and `Excel` file for testing.

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

Here, you dot source the PowerShell script and you can create a `DataFrame` from `CSV` data using the built-in `Import-Csv` PowerShell function  `ConvertTo-DataFrame (Import-Csv .\testData.csv)`.

```powershell
. .\cvtToDF.ps1

(ConvertTo-DataFrame (Import-Csv .\testData.csv)).GroupBy("Region").Sum("TotalSold").Sort("Region") | Out-DataFrame
```

```
Region TotalSold
------ ---------
East          83
North        174
South         61
West         183
```

`ConvertTo-DataFrame` returns a DataFrame so you can then do things like `GroupBy`, `Sum`, and `Sort` to get these results.

## PowerShell Excel and DataFrames

Since we're using PowerShell, we can pass any PowerShell array containing objects to `ConvertTo-DataFrame`.

Here, we're using `Import-Excel` to read a spreadsheet to create the DataFrame.

***Note***: You can get the PowerShell Excel module from the PowerShell Gallery `Install-Module ImportExcel`.

```powershell
. .\cvtToDF.ps1

(ConvertTo-DataFrame (Import-Excel .\testData.xlsx)).GroupBy("Region").Sum("TotalSold").Sort("Region") | Out-DataFrame
```

```
Region TotalSold
------ ---------
East          83
North        174
South         61
West         183
```

As before, `ConvertTo-DataFrame` returns a DataFrame so you can then use the `GroupBy`, `Sum`, and `Sort` methods to get these results.

## Perform a Computation

The DataFrame and DataFrameColumn classes expose a number of useful APIs. `Add-ToDF` *PowerShellizes* the `Add` method.

```powershell
. .\cvtToDF.ps1

$df = ConvertTo-DataFrame (Import-Excel .\testData.csv)
Add-ToDF -targetDF $df -ColumnName TotalSold -Value 100

# C# syntax
# $df[TotalSold].Add(100, $false)

# Add-ToDF -targetDF $df -ColumnName TotalSold -Value 100 -Inplace

# C# syntax
# $df[TotalSold].Add(100, $true)
```

It adds 100 to all the values in the `ColumnName` and returns them. If you use the `-InPlace` switch, it also updates the values in the DataFrame.

```
129
119
157
101
188
142
186
107
183
189
```

## Summary

The Microsoft DataFrame is a preview, and `ConvertTo-DataFrame` a proof of concept. It's an excellent playground to make data exploration easy.

Definitely give it a try.

<!-- chapter end -->

