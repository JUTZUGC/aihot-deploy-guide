# AIHOT 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/KKKKhazix/AIHOT/blob/main/README.md
# 更新日期：2026-10-28
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw '需要先安装 Node.js' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/KKKKhazix/AIHOT.git myhot
cd myhot
node -e "const m=+process.versions.node.split('.')[0]; if(m<24){console.error('需要 Node.js 24 或更高');process.exit(1)}"
$LLM_KEY = Read-Host '请输入 OpenAI 兼容模型 API Key'
node scripts/init-env.ts --llm-key $LLM_KEY
docker compose up -d --build

Write-Host ''
$url = 'http://127.0.0.1:3000'
Write-Host "等待服务启动：$url"
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
  try {
    Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 3 | Out-Null
    $ready = $true
    break
  } catch {
    Start-Sleep -Seconds 2
  }
}
if (-not $ready) { throw "60 秒内未探测到 $url，请手动打开确认或查看日志" }
Write-Host '服务已就绪'
Write-Host '部署完成：浏览器打开 http://127.0.0.1:3000，后台在 /admin，管理员密码在 .env 的 ADMIN_PASSWORD'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/KKKKhazix/AIHOT/blob/main/README.md'
