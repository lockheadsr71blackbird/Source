
function AddAlgoVPN {
  certutil -f -importpfx .\jivko.p12
  Add-VpnConnection -name "Algo VPN 192.241.158.243 IKEv2" -ServerAddress "192.241.158.243" -TunnelType IKEv2 -AuthenticationMethod MachineCertificate -EncryptionLevel Required
  Set-VpnConnectionIPsecConfiguration -ConnectionName "Algo VPN 192.241.158.243 IKEv2" -AuthenticationTransformConstants GCMAES128 -CipherTransformConstants GCMAES128 -EncryptionMethod AES128 -IntegrityCheckMethod SHA384 -DHGroup ECP256 -PfsGroup ECP256  -Force
}

function RemoveAlgoVPN {
  Get-ChildItem cert:LocalMachine/Root | Where-Object { $_.Subject -match '^CN=192.241.158.243$' -and $_.Issuer -match '^CN=192.241.158.243$' } | Remove-Item
  Get-ChildItem cert:LocalMachine/My | Where-Object { $_.Subject -match '^CN=jivko$' -and $_.Issuer -match '^CN=192.241.158.243$' } | Remove-Item
  Remove-VpnConnection -name "Algo VPN 192.241.158.243 IKEv2" -Force
}

switch ($args[0]) {
  "Add" { AddAlgoVPN }
  "Remove" { RemoveAlgoVPN }
  default { Write-Host Usage: $MyInvocation.MyCommand.Name "(Add|Remove)" }
}
