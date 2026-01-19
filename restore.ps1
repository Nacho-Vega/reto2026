# Script para obtener información básica de hardware en Windows

Write-Host "=== INFORMACIÓN DEL SISTEMA ===" -ForegroundColor Cyan

# Sistema
$cs = Get-CimInstance Win32_ComputerSystem
Write-Host "`n[Sistema]" -ForegroundColor Yellow
Write-Host "Fabricante: $($cs.Manufacturer)"
Write-Host "Modelo: $($cs.Model)"
Write-Host "RAM Total: $([math]::Round($cs.TotalPhysicalMemory / 1GB, 2)) GB"

# Procesador
$cpu = Get-CimInstance Win32_Processor
Write-Host "`n[Procesador]" -ForegroundColor Yellow
Write-Host "Nombre: $($cpu.Name)"
Write-Host "Núcleos: $($cpu.NumberOfCores)"
Write-Host "Hilos: $($cpu.NumberOfLogicalProcessors)"

# Discos
Write-Host "`n[Discos]" -ForegroundColor Yellow
Get-CimInstance Win32_DiskDrive | ForEach-Object {
    Write-Host "Modelo: $($_.Model) - Tamaño: $([math]::Round($_.Size / 1GB, 2)) GB"
}

# GPU
Write-Host "`n[Tarjeta Gráfica]" -ForegroundColor Yellow
Get-CimInstance Win32_VideoController | ForEach-Object {
    Write-Host "Nombre: $($_.Name)"
    Write-Host "RAM: $([math]::Round($_.AdapterRAM / 1GB, 2)) GB"
}

# Sistema Operativo
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "`n[Sistema Operativo]" -ForegroundColor Yellow
Write-Host "Nombre: $($os.Caption)"
Write-Host "Versión: $($os.Version)"
Write-Host "Arquitectura: $($os.OSArchitecture)"
