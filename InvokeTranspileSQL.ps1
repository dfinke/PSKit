#requires -Modules PSStringScanner

function ConvertFrom-SQLToPS {
    param(
        [Parameter(Mandatory)]
        $SQL
    )

    Invoke-TranspileSQL $SQL | ConvertFrom-TranspileSQL
}

function Add-PSOp {
    param($target)

    $target | Add-Member -PassThru -MemberType ScriptProperty -Name PSOp -Value {
        switch ($this.operation) {
            "<>" { "-ne" }
            ">=" { "-ge" }
            "<=" { "-le" }
            "=" { "-eq" }
            ">" { "-gt" }
            "<" { "-lt" }
            "like" { "-like" }
            "match" { "-match" }
            default { $_ }
        }
    }
}

function Add-PSLogicOp {
    param($target)

    $target | Add-Member -PassThru -MemberType ScriptProperty -Name PSLogicOp -Value {
        if ($this.LogicOp) {
            "-" + $this.LogicOp
        }
    }
}

function Invoke-TranspileSQL {
    param(
        [Parameter(Mandatory)]
        $SQL
    )

    $ss = New-PSStringScanner $sql

    $SELECT_KW = "^[Ss][Ee][Ll][Ee][Cc][Tt]\s+"
    $FROM_KW = "[Ff][Rr][Oo][Mm]"
    $WHERE_KW = "[Ww][Hh][Ee][Rr][Ee]"
    $OPERATIONS = "<>|<=|>=|>|<|=|like|match"
    $LOGICAL = "[Oo][rR]|[Aa][Nn][Dd]"
    $WHITESPACE = "\s+"

    $h = [Ordered]@{ }

    if ($ss.Check($SELECT_KW)) {
        $null = $ss.Scan($SELECT_KW)

        $h.SelectPropertyNames = ($ss.ScanUntil("(?=$FROM_KW)")).trim()

        if ($h.SelectPropertyNames.Contains(',')) {
            $h.SelectPropertyNames = $h.SelectPropertyNames.Split(',').foreach( { $_.trim() })
        }

        $null = $ss.Skip($FROM_KW)

        if ($ss.Check($WHERE_KW)) {
            $h.DataSetName = $ss.ScanUntil("(?=$WHERE_KW)").trim()
            $null = $ss.Skip("$WHERE_KW")

            $ssWhere = New-PSStringScanner $ss.Scan(".*")

            $whereResults = @()

            while (!$ssWhere.EoS()) {
                $currentResult = [Ordered]@{ }
                $currentResult.propertyName = $ssWhere.ScanUntil("(?=$OPERATIONS)").trim()
                $currentResult.operation = $ssWhere.Scan($OPERATIONS)

                if ($ssWhere.Check("$($WHITESPACE)$($LOGICAL)")) {
                    $currentResult.value = $ssWhere.ScanUntil("(?=$($WHITESPACE)$($LOGICAL))")
                    $currentResult.logicOp = $ssWhere.Scan($LOGICAL)
                }
                else {
                    $currentResult.value = $ssWhere.Scan('.*').Trim()
                }

                $obj = Add-PSOp ([PSCustomObject]$currentResult)
                $obj = Add-PSLogicOp $obj

                $whereResults += [PSCustomObject]$obj
            }
        }
        else {
            $h.DataSetName = $ss.Scan(".*").trim()
        }
    }

    if ($whereResults) {
        $h.where = [PSCustomObject[]]$whereResults
    }
    $h
}

function ConvertFrom-TranspileSQL {
    param(
        [Parameter(ValueFromPipeline)]
        [System.Collections.Specialized.OrderedDictionary]
        $map
    )

    $SelectPropertyNames = $map.SelectPropertyNames

    if ($SelectPropertyNames -ne '*') {
        $SelectPropertyNames = $SelectPropertyNames -join '","'
        $SelectPropertyNames = '"' + $SelectPropertyNames + '"'
    }

    if ($map.Contains("where")) {
        $sqlResult += "| Where-Object {"
        foreach ($whereRecord in $map.Where) {
            $sqlResult += '$_.{0} {1} {2} {3} ' -f $whereRecord.propertyName, $whereRecord.PSOp, $whereRecord.value.trim(), $whereRecord.PSLogicOp
            if ($null -eq $whereRecord.PSLogicOp) { $sqlResult = $sqlResult.Trim() }
        }
        $sqlResult += "}"
    }

    $sqlResult += " | Select-Object -Property $($SelectPropertyNames)"

    $sqlResult
}

Update-TypeData -Force -TypeName Array -MemberType ScriptMethod -MemberName query -Value {
    param($q)

    $psquery = Invoke-TranspileSQL $q | ConvertFrom-TranspileSQL

    Invoke-Expression "`$this $psquery"
}