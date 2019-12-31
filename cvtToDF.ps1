$basePath = "$pwd\bin"

$null = [System.Reflection.Assembly]::LoadFrom("$basePath\Apache.Arrow.dll")
$null = [System.Reflection.Assembly]::LoadFrom("$basePath\Microsoft.ML.DataView.dll")
$null = [System.Reflection.Assembly]::LoadFrom("$basePath\System.Runtime.CompilerServices.Unsafe.dll")
$null = [System.Reflection.Assembly]::LoadFrom("$basePath\Microsoft.Data.Analysis.dll")

. '.\InferData\InferData.ps1'

function Get-DataTypeInfo {
    param(
        $InputObject
    )

    $propertyNames = $InputObject[0].psobject.Properties.name

    foreach ($name in $propertyNames) {
        $r = Invoke-TestSet $InputObject[0].$name -First -OnlyPass
        [PSCustomObject][Ordered]@{
            PropertyName = $name
            DataType     = $r.DataType
        }
    }
}

function ConvertTo-DataFrame {
    param(
        $InputObject
    )

    $column = @()
    $colCount = 0
    $dataInfo = Get-DataTypeInfo $InputObject

    $dataInfo | ForEach-Object {
        if ($_.DataType -eq 'string') {
            $str = 'New-Object Microsoft.Data.Analysis.StringDataFrameColumn "{0}", {1}' -f $_.PropertyName, $InputObject.Count
        }
        else {
            $str = 'New-Object Microsoft.Data.Analysis.PrimitiveDataFrameColumn[{0}] "{1}", {2}' -f $_.DataType, $_.PropertyName, $InputObject.Count
        }

        $vName = "Col_$($colCount)"
        $column += $vName
        $v = ($str | Invoke-Expression)
        Set-Variable -Name "$vName" -Value $v
        $colCount++
    }

    $dfStr = 'New-Object Microsoft.Data.Analysis.DataFrame ${0}' -f ($Column -join ', $')
    $df = $dfStr | Invoke-Expression

    $row = 0
    foreach ($item in $InputObject) {
        foreach ($col in 0..($dataInfo.Count - 1)) {
            $df[$row, $col] = $item.($dataInfo[$col].propertyname) -as $dataInfo[$col].datatype
        }
        $row++
    }

    $df
}

function Out-DataFrame {
    param(
        [Parameter(ValueFromPipeline)]
        $dataFrame
    )

    Process {
        $names = $dataFrame.Columns.Name
        for ($i = 0; $i -lt $dataFrame.Rows.Count; $i++) {

            $h = [ordered]@{ }
            $colCount = 0
            foreach ($column in $dataFrame.Rows[$i]) {
                $colName = $names[$colCount++]
                $h.$colName = $column
            }

            [PSCustomObject]$h
        }
    }
}

Set-Alias -Name odf -Value Out-DataFrame

function Add-ToDF {
    param(
        $targetDF,
        $ColumnName,
        $value,
        [Switch]$Inplace
    )

    $flag = $false
    if ($Inplace) { $flag = $true }

    $targetDF[$ColumnName].Add($value, $flag)
}