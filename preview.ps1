# 本地预览博客脚本
# 用法: 双击 预览博客.bat, 浏览器自动打开 http://localhost:1313/
$ErrorActionPreference = "Stop"
$blogDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $blogDir

Write-Host ""
Write-Host "正在启动本地预览 ..." -ForegroundColor Cyan
Write-Host "浏览器将打开 http://localhost:1313/" -ForegroundColor Cyan
Write-Host "关闭本窗口(Ctrl+C)即停止预览。" -ForegroundColor Cyan
Write-Host ""
Start-Process "http://localhost:1313/"
hugo server -D --disableFastRender
