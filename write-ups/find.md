# Find properties matching a regular expression

```powershell
$data = ConvertFrom-Csv @"
name,phone_number,location
Chris,555-999-1111,Cushing House
Brian,555-123-4567,Prescott House
Ryan,555-123-8901,Oliver House
Joe,555-777-1111,Oliver House
"@
```

Find phone numbers following the pattern "ddd–123-dddd":

```powershell
PS C:\> $data.ScanProperties("\d{3}-123-\d{4}")

name  phone_number location
----  ------------ --------
Brian 555-123-4567 Prescott House
Ryan  555-123-8901 Oliver House
```

Find any record whose properties match  "ryan" or "prescott"

```powershell
PS C:\> $data.ScanProperties("ryan|prescott")

name  phone_number location
----  ------------ --------
Brian 555-123-4567 Prescott House
Ryan  555-123-8901 Oliver House
```