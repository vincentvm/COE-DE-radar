#
# Script module for module 'Az.Resources' that is executed when 'Az.Resources' is imported in a PowerShell session.
#
# Generated by: Microsoft Corporation
#
# Generated on: 04/29/2021 10:04:29
#

$PSDefaultParameterValues.Clear()
Set-StrictMode -Version Latest

function Test-DotNet
{
    try
    {
        if ((Get-PSDrive 'HKLM' -ErrorAction Ignore) -and (-not (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -ErrorAction Stop | Get-ItemPropertyValue -ErrorAction Stop -Name Release | Where-Object { $_ -ge 461808 })))
        {
            throw ".NET Framework versions lower than 4.7.2 are not supported in Az.  Please upgrade to .NET Framework 4.7.2 or higher."
        }
    }
    catch [System.Management.Automation.DriveNotFoundException]
    {
        Write-Verbose ".NET Framework version check failed."
    }
}

if ($true -and ($PSEdition -eq 'Desktop'))
{
    if ($PSVersionTable.PSVersion -lt [Version]'5.1')
    {
        throw "PowerShell versions lower than 5.1 are not supported in Az. Please upgrade to PowerShell 5.1 or higher."
    }

    Test-DotNet
}

if ($true -and ($PSEdition -eq 'Core'))
{
    if ($PSVersionTable.PSVersion -lt [Version]'6.2.4')
    {
        throw "Current Az version doesn't support PowerShell Core versions lower than 6.2.4. Please upgrade to PowerShell Core 6.2.4 or higher."
    }
}

if (Test-Path -Path "$PSScriptRoot\StartupScripts" -ErrorAction Ignore)
{
    Get-ChildItem "$PSScriptRoot\StartupScripts" -ErrorAction Stop | ForEach-Object {
        . $_.FullName
    }
}

if (Get-Module AzureRM.profile -ErrorAction Ignore)
{
    Write-Warning ("AzureRM.Profile already loaded. Az and AzureRM modules cannot be imported in the same session or used in the same script or runbook. If you are running PowerShell in an environment you control you can use the 'Uninstall-AzureRm' cmdlet to remove all AzureRm modules from your machine. " +
        "If you are running in Azure Automation, take care that none of your runbooks import both Az and AzureRM modules. More information can be found here: https://aka.ms/azps-migration-guide.")
    throw ("AzureRM.Profile already loaded. Az and AzureRM modules cannot be imported in the same session or used in the same script or runbook. If you are running PowerShell in an environment you control you can use the 'Uninstall-AzureRm' cmdlet to remove all AzureRm modules from your machine. " +
        "If you are running in Azure Automation, take care that none of your runbooks import both Az and AzureRM modules. More information can be found here: https://aka.ms/azps-migration-guide.")
}

$preloadPath = (Join-Path $PSScriptRoot -ChildPath "PreloadAssemblies")
if($PSEdition -eq 'Desktop' -and (Test-Path $preloadPath -ErrorAction Ignore))
{
    try
    {
        Get-ChildItem -ErrorAction Stop -Path $preloadPath -Filter "*.dll" | ForEach-Object {
            try
            {
                Add-Type -Path $_.FullName -ErrorAction Ignore | Out-Null
            }
            catch {
                Write-Verbose $_
            }
        }
    }
    catch {}
}

$netCorePath = (Join-Path $PSScriptRoot -ChildPath "NetCoreAssemblies")
if($PSEdition -eq 'Core' -and (Test-Path $netCorePath -ErrorAction Ignore))
{
    try
    {
        $loadedAssemblies = ([System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {New-Object -TypeName System.Reflection.AssemblyName -ArgumentList $_.FullName} )
        Get-ChildItem -ErrorAction Stop -Path $netCorePath -Filter "*.dll" | ForEach-Object {
            $assemblyName = ([System.Reflection.AssemblyName]::GetAssemblyName($_.FullName))
            $matches = ($loadedAssemblies | Where-Object {$_.Name -eq $assemblyName.Name})
            if (-not $matches)
            {
                try
                {
                    Add-Type -Path $_.FullName -ErrorAction Ignore | Out-Null
                }
                catch {
                    Write-Verbose $_
                }
            }
        }
    }
    catch {}
}


$module = Get-Module Az.Accounts 
        if ($module -ne $null -and $module.Version -lt [System.Version]"2.2.8") 
{ 
    Write-Error "This module requires Az.Accounts version 2.2.8. An earlier version of Az.Accounts is imported in the current PowerShell session. Please open a new session before importing this module. This error could indicate that multiple incompatible versions of the Azure PowerShell cmdlets are installed on your system. Please see https://aka.ms/azps-version-error for troubleshooting information." -ErrorAction Stop 
} 
elseif ($module -eq $null) 
{ 
    Import-Module Az.Accounts -MinimumVersion 2.2.8 -Scope Global 
}
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.Azure.PowerShell.Cmdlets.Resources.dll)
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.Azure.PowerShell.Cmdlets.ResourceManager.dll)
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.Azure.PowerShell.Cmdlets.Tags.dll)


if (Test-Path -Path "$PSScriptRoot\PostImportScripts" -ErrorAction Ignore)
{
    Get-ChildItem "$PSScriptRoot\PostImportScripts" -ErrorAction Stop | ForEach-Object {
        . $_.FullName
    }
}

$FilteredCommands = @('New-AzManagedApplication:ResourceGroupName','New-AzManagedApplicationDefinition:ResourceGroupName','Get-AzResourceGroupDeploymentOperation:ResourceGroupName','Get-AzResourceGroupDeploymentWhatIfResult:ResourceGroupName','New-AzResourceGroupDeployment:ResourceGroupName','Save-AzResourceGroupDeploymentTemplate:ResourceGroupName','Test-AzResourceGroupDeployment:ResourceGroupName','Export-AzResourceGroup:ResourceGroupName')

if ($Env:ACC_CLOUD -eq $null)
{
    $FilteredCommands | ForEach-Object {

        $existingDefault = $false
        foreach ($key in $global:PSDefaultParameterValues.Keys)
        {
    	    if ($_ -like "$key")
    	        {
        	    $existingDefault = $true
    	        }
	    }

        if (!$existingDefault)
        {
            $global:PSDefaultParameterValues.Add($_,
                {
                    if ((Get-Command Get-AzContext -ErrorAction Ignore) -eq $null)
                    {
                        $context = Get-AzureRmContext
                    }
                    else
                    {
                        $context = Get-AzContext
                    }
                    if (($context -ne $null) -and $context.ExtendedProperties.ContainsKey("Default Resource Group")) {
                        $context.ExtendedProperties["Default Resource Group"]
                    }
                })
        }
    }
}

# SIG # Begin signature block
# MIIjkQYJKoZIhvcNAQcCoIIjgjCCI34CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAi0/Rx1KfoDDUI
# JIgbfN/uJRp8bP3DN9hmwjP/0Y0Z0aCCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVZjCCFWICAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgxGDl1iu7
# OTxfTqfmou2rBWT7g6zICiwR6lGUME5aqxMwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQBKmLPbvZIg8aH8WsjYxzcs004WUVuYthLh4hU+1gqv
# /HMjxdj3vPOcKULpesXxp62CM1la5ZNsfwTTcG6oIU2tn+cRZ10qWb+PJjA0PrHC
# /dojQ+fhckWiG5EuXLrx5gGDx4bXspO353vJM55ip2QY4NEnHO4rQz6TjXswelJy
# 22eAiUSBKjHIlrIs9rNw5V776ccNyf7ER1Of27FtyKMXuD28SeGWDgoJEKPEfWCv
# X7zKW5Vha+nfqWAzDOSLOiqKYIjWlnQvxikj4BT77X7orzlSAHzjxTJtuSe5SKGO
# JqBkWm2x7mDDAQmbcdVSfGu17xpjObEpPLn45kRz/PuroYIS8DCCEuwGCisGAQQB
# gjcDAwExghLcMIIS2AYJKoZIhvcNAQcCoIISyTCCEsUCAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIB93knNCDjzKRTso6MnZhxkVH3EL85PmSsx4CAwz
# ocGdAgZgiflSFFYYEzIwMjEwNDI5MTA1MTQxLjIyM1owBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjo2MEJDLUUzODMtMjYzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCDkMwggT1MIID3aADAgECAhMzAAABWiy5bkQ0y28oAAAA
# AAFaMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIxMDExNDE5MDIxNloXDTIyMDQxMTE5MDIxNlowgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo2MEJD
# LUUzODMtMjYzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALC9XBxXDa0nCK70Hf+G
# ih6NxRl1mAhzFJdok8bs3xpJ87TM28rEeHkZAaE+Kb9Gi9UvTpQ3zrEWyWSpIQky
# xv/Wf0cIhA1mJOqyu20TN3l96ZvgzYrzO/rQlPvbKW79oAO4+YFsekQCtrzM9hQo
# S5BYGwPh9Qz66BuSxH9QweywNBQsjkVoikpBxkS+EXSIzpba2afvnRMX7LLe2ery
# c+PlPXmTSOfH1WNykc25u9zo6ZX0gAd4jUpBzdMLnHCtE62bL2PO00cmAJsitqga
# ov+3lFrfd0sPACwTGO9iymlJlb2savwjqSnj5RzG4RxG6rU2i7etbnQTozR73OHM
# GOUCAwEAAaOCARswggEXMB0GA1UdDgQWBBRkcyU/9RyPkn7QBoXZOTQ8wN4xZzAf
# BgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQAAAG3sfFgbUiw4gWMV8VOxlbIG/CIM
# SiciDtIZnPL84OMN4lJeV5LeJr+HYBcox5ruWZm49K29iBmJv6ViXMtP81pYZ1EF
# M7306Y+zLIh/tS574PeWsHvPD0QOxQ4HOM2GNPvFAdUvo8z5pgV/5E+lPu61uUCI
# BTDESiHO+N7ragqb3METPqRKPLNAJcKPDcalKznmGPlnzY6P1zop/7a90VcBHRKK
# Q/hTvn/8C8Y6b+Mvk5kYJh67KNbVVcuuBWyFSMZTHGenHnuHVg9svH7+lm/V/wIb
# ZUKKJJO0HQmyodySeD/JLC7NNsDYRpFN+29dLRtx0eWyZosJmT8qKbBIMIIGcTCC
# BFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJv
# b3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcN
# MjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0
# VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEw
# RA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQe
# dGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKx
# Xf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4G
# kbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEA
# AaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7
# fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0g
# AQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYB
# BQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUA
# bQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOh
# IW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS
# +7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlK
# kVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon
# /VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOi
# PPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/
# fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCII
# YdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0
# cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7a
# KLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQ
# cdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+
# NR4Iuto229Nfj950iEkSoYIC0TCCAjoCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBP
# cGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo2
# MEJDLUUzODMtMjYzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAzIAFmL3GHHWcAJYi3haGwlplGi6ggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOQ0d9AwIhgPMjAyMTA0MjkwNDA5NTJaGA8yMDIxMDQzMDA0MDk1MlowdjA8Bgor
# BgEEAYRZCgQBMS4wLDAKAgUA5DR30AIBADAJAgEAAgEGAgH/MAcCAQACAhDfMAoC
# BQDkNclQAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEA
# AgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAcmDDRxqZBA06WKIO
# qVujBKupMQ4mOlor1oraGyPGtO/eFueKsYtz09hAWCykFeP8JqVOTIWUOLuWOu+a
# s5YRnoTfsv+QICjbGKE6W44SH8lLJJ5sEaYBt3em8BF7TWUeC9XP2K3UszXIomZ8
# NN9Jr7VGg4Zj2H4Fsm8AX0dF5SsxggMNMIIDCQIBATCBkzB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMAITMwAAAVosuW5ENMtvKAAAAAABWjANBglghkgBZQME
# AgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJ
# BDEiBCCDpGj2jpZYqGIEntUDe4rCk9SqFQzhIJZWfP16azk0ADCB+gYLKoZIhvcN
# AQkQAi8xgeowgecwgeQwgb0EIJP8qCZ0xLLkXTDDghqv1yZ/kizekzSFS4gicvlt
# sX+wMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAFa
# LLluRDTLbygAAAAAAVowIgQgLt54uLkxdPTCUKCO9EZ4DWfChGp/EeqjXp5jYiq9
# UYowDQYJKoZIhvcNAQELBQAEggEAAveYYs7be/4uxgt7NKPuYOdO2mtKwX4yFHDo
# vmYS+bPSqlXUDm+EnOMaopoBqUcPdy+89iaNoVyQKEp2Tv7PwO13z5q+nf/sgo2a
# 7FEskqjzTXfDsaFDbhQMTNdRFSDVLqss+8tCMsX/dVAPqu+5ecTt1mL8OmyFBiWu
# It926bayRrk1p5oCE0Fgm53dxNu+puzTLycO3vy//FffB/rZqVOWqqeecN3I3DTm
# fEP1bzvP06SEAozqjeGcEkXAYl8AgsDJd4xHda+GI6J5kH7cvAKurLAbHGAkzYF7
# SnK1MjPXr2aktNAUlYu1hp265OTyr6PEMaNrd5T8368xmpsoJQ==
# SIG # End signature block
