# Generate summary statistics for PowerShell Arrays

Calculates different statistics based on the type of each column

```powershell
PS C:\> $data = ConvertFrom-Csv @"
name,age,cash,dateAdded
Chris,44,72,1/1
Brian,26,110,3/2
Ryan,18,145
Joe,34,83,4/7
Ryan,27,300
,98,1,6/9
"@

PS C:\ $data.Stats()
````

```powershell
ColumnName DataType HasNulls Min Max Range Median StandardDeviation Variance         Sum
---------- -------- -------- --- --- ----- ------ ----------------- --------         ---
name       string       True             0
age        int         False 18  98     80 30.5   29.1781882005492  851.366666666667 247
cash       int         False 1   300   299 96.5   100.941071918224  10189.1          711
dateAdded  datetime     True             0
```