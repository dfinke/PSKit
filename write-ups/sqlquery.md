# Execute a SQL SELECT query directly on PowerShell Arrays

```powershell
class Person {
    $Name
    [int]$Age
    [int]$Cash
}

[Person[]]$data = ConvertFrom-Csv @"
name,age,cash
Chris,44,72
Brian,26,110
Ryan,18,145
Joe,34,83
"@

$data.query("SELECT cash, name FROM data where name like '*i*' and cash > 100")
```

```powershell
cash name
---- ----
110  Brian
```