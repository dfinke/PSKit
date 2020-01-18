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

    It "Should parse data with whitespace in the begining" -Skip {
        $data = @"
   PID TTY          TIME CMD
   103 pts/0    00:00:00 bash
   136 pts/0    00:00:13 pwsh
   305 pts/0    00:00:00 ps

"@

        $actual = $data -split "`n" | ConvertFrom-SSV

    }
}