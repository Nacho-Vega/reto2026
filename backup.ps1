[CmdletBinding()]
param(
	[Parameter(Mandatory=$true)][string]$HostName,
	[Parameter(Mandatory=$true)][string]$User,
	[string]$IdentityFile,
	[int]$Port = 22,
	[string]$SourcePath = "/var/www/html",
	[string]$LocalBackupDir = "$PWD\backups",
	[int]$RetentionDays = 0,
	[switch]$DryRun
)
# Configurar para detenerse en errores
$ErrorActionPreference = "Stop"

function Exec {
	param([string]$file, [string[]]$args)
	if ($DryRun) {
		Write-Host "$file $($args -join ' ')"
		return
	}
	& $file @args
	if ($LASTEXITCODE -ne 0) { throw "$file failed with exit code $LASTEXITCODE" }
}

if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) { throw "ssh no está instalado en este sistema." }
if (-not (Get-Command scp -ErrorAction SilentlyContinue)) { throw "scp no está instalado en este sistema." }
if ($IdentityFile) {
	if (-not (Test-Path $IdentityFile)) { throw "No se encontró el archivo de clave: $IdentityFile" }
}

if (-not (Test-Path $LocalBackupDir)) { New-Item -ItemType Directory -Path $LocalBackupDir | Out-Null }

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$remoteTempFile = "/tmp/html-backup-$timestamp.tar.gz"
$localFilePath = Join-Path $LocalBackupDir "html-backup-$timestamp.tar.gz"

$sshArgs = @()
if ($IdentityFile) { $sshArgs += @('-i', $IdentityFile) }
$sshArgs += @('-p', $Port)

$remoteTarCmd = "sudo tar -czf '$remoteTempFile' -C '$SourcePath' ."
$sshArgsCreate = $sshArgs + @("$User@$HostName", $remoteTarCmd)
Exec 'ssh' $sshArgsCreate

$scpArgs = @()
if ($IdentityFile) { $scpArgs += @('-i', $IdentityFile) }
$scpArgs += @('-P', $Port, "$User@$HostName:$remoteTempFile", $localFilePath)
Exec 'scp' $scpArgs

$remoteCleanupCmd = "sudo rm -f '$remoteTempFile'"
$sshArgsCleanup = $sshArgs + @("$User@$HostName", $remoteCleanupCmd)
Exec 'ssh' $sshArgsCleanup

$hash = if (-not $DryRun) { (Get-FileHash -Algorithm SHA256 -Path $localFilePath).Hash } else { "" }

if ($RetentionDays -gt 0) {
	$cutoff = (Get-Date).AddDays(-$RetentionDays)
	Get-ChildItem -Path $LocalBackupDir -Filter "html-backup-*.tar.gz" | Where-Object { $_.LastWriteTime -lt $cutoff } | Remove-Item -Force
}

if (-not $DryRun) {
	Write-Output "Backup creado: $localFilePath"
	Write-Output "SHA256: $hash"
} else {
	Write-Output "DryRun completado. No se realizó copia."
}

#hola