# 新建博客文章脚本
# 用法: 双击 新建文章.bat 即可
$ErrorActionPreference = "Stop"
$blogDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$postsDir = Join-Path $blogDir "content\posts"
if (-not (Test-Path $postsDir)) { New-Item -ItemType Directory -Path $postsDir -Force | Out-Null }

Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "     新建博客文章" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""
$title = Read-Host "请输入文章标题"
if ([string]::IsNullOrWhiteSpace($title)) {
    Write-Host "标题不能为空。" -ForegroundColor Red
    Read-Host "按回车键关闭"
    exit 1
}

# 生成文件名: YYYY-MM-DD-标题.md (自动去掉非法字符)
$date = Get-Date -Format "yyyy-MM-dd"
$slug = ($title.Trim() -replace '\s+', '-' -replace '[\\/:*?"<>|]', '')
$filename = "$date-$slug.md"
$filepath = Join-Path $postsDir $filename

$timestamp = Get-Date -Format "yyyy-MM-dd'T'HH:mm:sszzz"
$front = @"
---
title: "$title"
date: $timestamp
draft: false
description: ""
tags: []
categories: []
---

在这里开始写作...
"@

[System.IO.File]::WriteAllText($filepath, $front, (New-Object System.Text.UTF8Encoding $true))
Write-Host ""
Write-Host "文章已创建: $filename" -ForegroundColor Green

# 用系统默认编辑器打开(Markdown 文件)
try { Start-Process $filepath } catch { }
Write-Host ""
Write-Host "写完并保存后, 双击「发布博客.bat」即可上线。" -ForegroundColor Yellow
Read-Host "按回车键关闭"
