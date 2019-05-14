<#
    .SYNOPSIS
    Show only the property names of an object

    .EXAMPLE
    Get-Service | Get-PropertyName

Name
RequiredServices
CanPauseAndContinue
CanShutdown
CanStop
DisplayName
DependentServices
MachineName
ServiceName
ServicesDependedOn
ServiceHandle
Status
ServiceType
StartType
Site
Container
#>
function Get-PropertyName {
    param(
        $Name,
        [Parameter(ValueFromPipeline)]
        $Data,
        $InputObject
    )

    Begin {
        if (!$InputObject) { $list = @() }
    }

    Process {
        if (!$InputObject) { $list += $Data }
    }

    End {
        if (!$InputObject) {
            $names = $List[0].psobject.properties.name
        }
        else {
            $names = $InputObject[0].psobject.properties.name
        }

        if (!$name) { $name = "*" }

        $names.Where( { $_ -like $name } )
    }
}