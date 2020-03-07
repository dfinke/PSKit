function New-DataFrame {
    <#
        .Synopsis
        Array of objects, size-mutable, can be heterogeneous, tabular data

        .Example
        New-DataFrame (Get-DateRange 1/1 -periods 5) p1,p2,3 {Get-Random}
Index              p1         p2          3
-----              --         --          -
2020-01-01  708420917 1112428663  523426202
2020-01-02 1643869654 2086787197 1127195815
2020-01-03 1095068483 2006354687 1612194161
2020-01-04 1561123134 1004618008 1431794170
2020-01-05  851611997  189055864  871342612

        .Example
        New-DataFrame (Get-DateRange 1/1 -periods 5) p1,p2,3
Index      p1        p2        3
-----      --        --        -
2020-01-01 [missing] [missing] [missing]
2020-01-02 [missing] [missing] [missing]
2020-01-03 [missing] [missing] [missing]
2020-01-04 [missing] [missing] [missing]
2020-01-05 [missing] [missing] [missing]

        .Example
        New-DataFrame (Get-DateRange 1/1 -periods 5 -freq M) person,state,region {Invoke-Generate "$args"}
Index      person         state         region
-----      ------         -----         ------
2020-01-01 Jalen Austin   Oklahoma      East
2020-02-01 Jaydon Pratt   Nevada        North
2020-03-01 Jazlynn Zuniga Florida       West
2020-04-01 Dylan Nash     Nebraska      South
2020-05-01 Jabari Dodson  Massachusetts West

        .Example
        New-DataFrame -data (1..3) -propertyNames a,b,c,d -getRandomData {2*[math]::pi}
Index                a                b                c                d
-----                -                -                -                -
    1 6.28318530717959 6.28318530717959 6.28318530717959 6.28318530717959
    2 6.28318530717959 6.28318530717959 6.28318530717959 6.28318530717959
    3 6.28318530717959 6.28318530717959 6.28318530717959 6.28318530717959
    #>
    param($data, $propertyNames, [scriptblock]$getRandomData = { '[missing]' })

    foreach ($row in $data) {
        $obj = [Ordered]@{Index = $row }
        foreach ($propertyName in $propertyNames) {
            $obj.$propertyName = &$getRandomData $propertyName
        }

        [PSCustomObject]$obj
    }
}
