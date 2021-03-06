Import-Module $PSScriptRoot/../PSKit.psd1 -Force

Describe "PSKit tests - Test ConverFrom-SSV" {
    It "Should be docker data" {
        $data = @"
NAME              LABELS                                    SELECTOR                  IP              PORT(S)
docker-registry   docker-registry=default                   docker-registry=default   172.30.78.158   5000/TCP
kubernetes        component=apiserver,provider=kubernetes   <none>                    172.30.0.2      443/TCP
kubernetes-ro     component=apiserver,provider=kubernetes   <none>                    172.30.0.1      80/TCP
"@

        # $actual = $data -split "`n" | ConvertFrom-SSV | Select-Object -Skip 1 -First 1
        $actual = $data -split "`n" | ConvertFrom-SSV
        $expected = "172.30.0.2"

        $actual[1].IP | should be $expected
    }

    It  "Should parse simple data with blank lines" {
        $data = @"
a       b

1       2

3       4
"@

        $actual = $data -split "`n" | ConvertFrom-SSV

        $actual[0].a | should be 1
        $actual[1].b | should be 4
    }

    It "Should parse" {
        $data = @"
a
1
2
"@
        $actual = $data -split "`n" | ConvertFrom-SSV

        $actual[0].a | should be 1
        $actual[1].a | should be 2
    }

    It "Should parse pulumi data" {
        $data = @"
NAME                                                 LAST UPDATE   RESOURCE COUNT  URL
dfinke/azure-functions-raw/dev                       4 months ago  0               https://app.pulumi.com/dfinke/azure-functions-raw/dev
dfinke/azure-py-webserver-component/pulumicomponent  2 months ago  0               https://app.pulumi.com/dfinke/azure-py-webserver-component/pulumicomponent
dfinke/foo/dev                                       3 months ago  0               https://app.pulumi.com/dfinke/foo/dev
dfinke/guestbook-csharp/kubernetes-cs                n/a           n/a             https://app.pulumi.com/dfinke/guestbook-csharp/kubernetes-cs
dfinke/kata/dev                                      4 months ago  0               https://app.pulumi.com/dfinke/kata/dev
"@
        $actual = $data -split "`n" | ConvertFrom-SSV
        $expected = "4 months ago"

        $actual[4].'LAST UPDATE' | should be $expected
    }

    It "Should parse data with whitespace in the begining" {
        $data = @"
   PID TTY          TIME CMD
   103 pts/0    00:00:00 bash
   136 pts/0    00:00:13 pwsh
   305 pts/0    00:00:00 ps

"@

        $actual = $data -split "`n" | ConvertFrom-SSV -min 1
        $names = $actual[0].psobject.properties.name

        $names.Count | Should Be 4
        $names[0] | Should BeExactly "PID"
        $names[1] | Should BeExactly "TTY"
        $names[2] | Should BeExactly "TIME"
        $names[3] | Should BeExactly "CMD"

        $actual[0].PID | Should Be 103
        $actual[1].PID | Should Be 136
        $actual[2].PID | Should Be 305

        $actual[0].TTY | Should Be "pts/0"
        $actual[1].TTY | Should Be "pts/0"
        $actual[2].TTY | Should Be "pts/0"

        $actual[0].TIME | Should Be "00:00:00"
        $actual[1].TIME | Should Be "00:00:13"
        $actual[2].TIME | Should Be "00:00:00"

        $actual[0].CMD | Should Be "bash"
        $actual[1].CMD | Should Be "pwsh"
        $actual[2].CMD | Should Be "ps"
    }

    It "Should multi whitespace" {
        $data = @"
            column a   column b
            entry 1    entry number  2
            3          four
"@

        $actual = $data -split "`n" | ConvertFrom-SSV -MinimumWhiteSpaceLength 3

        $names = $actual[0].psobject.properties.name
        $actual.count | should be 2

        $names[0] | should beexactly 'column a'
        $names[1] | should beexactly 'column b'

        $actual[0].'column a' | should beexactly 'entry 1'
        $actual[1].'column a' | should beexactly 3

        $actual[0].'column b' | should beexactly 'entry number  2'
        $actual[1].'column b' | should beexactly 'four'
    }

    It "Should multi whitespace and single row" {
        $data = @"
            colA   colB     colC
            val1   val2     val3
"@
        $actual = @($data -split "`n" | ConvertFrom-SSV -MinimumWhiteSpaceLength 3)
        $names = $actual[0].psobject.properties.name

        $actual.Count | Should be 1
        $names.Count | Should be 3

        $actual[0].colA | Should beexactly 'val1'
        $actual[0].colB | Should beexactly 'val2'
        $actual[0].colC | Should beexactly 'val3'
    }

    It "Should multi whitespace and single row" -Skip {
        $data = @"
                colA   col B     col C
                       val2      val3
                val4   val 5     val 6
                val7             val8

    "@
            $actual = @($data -split "`n" | ConvertFrom-SSV -MinimumWhiteSpaceLength 3)
            $names = $actual[0].psobject.properties.name

            $names.Count | Should be 3

    }

    It "Should handle trailing values" -Skip {
        $data = @"
            colA   col B
            val1   val2   trailing value that should be included
"@
        $actual = @($data -split "`n" | ConvertFrom-SSV )
        $names = $actual[0].psobject.properties.name

        $actual.Count | Should be 1
        $names.Count | Should be 2

        $actual[0].colA | Should beexactly 'val1'
        #$actual[0].colB | Should beexactly 'val2'
    }

}