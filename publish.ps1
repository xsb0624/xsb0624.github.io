# 博客一键发布脚本
# 用法: 双击 发布博客.bat 即可
$ErrorActionPreference = "Stop"
$blogDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $blogDir

Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "     博客一键发布" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# 1. 构建网站
Write-Host "[1/3] 正在构建网站 ..." -ForegroundColor Yellow
hugo --minify
if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败! 请检查文章格式是否正确。" -ForegroundColor Red
    Read-Host "按回车键关闭"
    exit 1
}
Write-Host "构建完成。" -ForegroundColor Green
Write-Host ""

# 2. 检查更改并提交
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "[2/3] 没有检测到新的更改。" -ForegroundColor Yellow
} else {
    Write-Host "[2/3] 正在提交更改 ..." -ForegroundColor Yellow
    git add -A
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    git commit -m "发布博客更新 $stamp"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "提交失败。" -ForegroundColor Red
        Read-Host "按回车键关闭"
        exit 1
    }
    Write-Host "提交完成。" -ForegroundColor Green
}
Write-Host ""

# 3. 推送到 GitHub
Write-Host "[3/3] 正在上传到 GitHub ..." -ForegroundColor Yellow
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "上传失败(网络可能不稳定), 请稍后重新运行本脚本。" -ForegroundColor Red
    Read-Host "按回车键关闭"
    exit 1
}
Write-Host ""
Write-Host "发布成功!" -ForegroundColor Green
Write-Host "等待 1-2 分钟后访问: https://yizhixiong.com/" -ForegroundColor Green
Write-Host ""
Read-Host "按回车键关闭"
