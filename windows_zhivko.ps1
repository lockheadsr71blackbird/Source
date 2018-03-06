
function AddAlgoVPN {
  certutil -f -importpfx .\zhivko.p12
  Add-VpnConnection -name "Algo VPN 159.65.101.154 IKEv2" -ServerAddress "159.65.101.154" -TunnelType IKEv2 -AuthenticationMethod MachineCertificate -EncryptionLevel Required
  Set-VpnConnectionIPsecConfiguration -ConnectionName "Algo VPN 159.65.101.154 IKEv2" -AuthenticationTransformConstants GCMAES128 -CipherTransformConstants GCMAES128 -EncryptionMethod AES128 -IntegrityCheckMethod SHA384 -DHGroup ECP256 -PfsGroup ECP256  -Force
}

function RemoveAlgoVPN {
  Get-ChildItem cert:LocalMachine/Root | Where-Object { $_.Subject -match '^CN=159.65.101.154$' -and $_.Issuer -match '^CN=159.65.101.154$' } | Remove-Item
  Get-ChildItem cert:LocalMachine/My | Where-Object { $_.Subject -match '^CN=zhivko$' -and $_.Issuer -match '^CN=159.65.101.154$' } | Remove-Item
  Remove-VpnConnection -name "Algo VPN 159.65.101.154 IKEv2" -Force
}

switch ($args[0]) {
  "Add" { AddAlgoVPN }
  "Remove" { RemoveAlgoVPN }
  default { Write-Host Usage: $MyInvocation.MyCommand.Name "(Add|Remove)" }
}
