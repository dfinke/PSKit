# Create a Lookup Table

Have data that with a unique id column? Want to use it as a lookup table? Here you go:

```powershell
PS C:\> $data = ConvertFrom-Csv @"
slug,place,latitude,longitude
dcl,Downtown Coffee Lounge,32.35066,-95.30181
tyler-museum,Tyler Museum of Art,32.33396,-95.28174
genecov,Genecov Sculpture,32.299076986939205,-95.31571447849274
"@
```

Similar to `Group-Object` in PowerShell. New-LookupTable handles missing data.

```
PS C:\> New-LookupTable $data slug

Name                           Value
----                           -----
dcl                            @{slug=dcl; place=Downtown Coffee Lounge; latitude=32.35066; longitude=-95.30181}
tyler-museum                   @{slug=tyler-museum; place=Tyler Museum of Art; latitude=32.33396; longitude=-95.28174}
genecov                        @{slug=genecov; place=Genecov Sculpture; latitude=32.299076986939205; longitude=-95.3157144...

```