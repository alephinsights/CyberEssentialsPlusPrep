#run script from Admin Powershell

$registryPath = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$name = "LocalAccountTokenFilterPolicy"
$value = "0"
$keyType = "DWORD"


try {
    IF (!(Test-Path $registryPath))
    {
        echo "path does not exist - creating path and key"
        New-Item -Path $registryPath -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType $keyType -Force | Out-Null
    }

    ELSE {
        echo "Key path exists - updating key"
        New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType $keyType -Force | Out-Null
    }
}
catch {
    Return $false
}

try {
    echo "set service to Disabled and stopping"
    Set-Service RemoteRegistry -StartupType Disabled
    Stop-Service RemoteRegistry
}
catch {
    echo "failed to start stop"
    retrun $false
}