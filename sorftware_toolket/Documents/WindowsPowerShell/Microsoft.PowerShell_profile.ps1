# ========== 别名 ==========
Set-Alias -Name clr -Value Clear-Host
Set-Alias -Name ll -Value ls
Set-Alias -Name lll -Value ls
# ========== SSH 主机名 Tab 补全（PowerShell 5.1 可靠方案） ==========

# 包装函数：把 ssh/scp/sftp 替换为 PowerShell 函数，以便拦截 Tab
function ssh  { & ssh.exe  @args }
function scp  { & scp.exe  @args }
function sftp { & sftp.exe @args }

# 保存原始的 TabExpansion2（只保存一次）
if (-not $global:__OrigTabExpansion2) {
    $global:__OrigTabExpansion2 = (Get-Command TabExpansion2 -CommandType Function).ScriptBlock
}

# 自定义 TabExpansion2：命中 ssh/scp/sftp 时用 ~/.ssh/config 的主机名补全
function global:TabExpansion2 {
    param($inputScript, $cursorColumn, $options)

    $line = $inputScript.Substring(0, [Math]::Min($cursorColumn, $inputScript.Length))

    if ($line -match '^\s*(ssh|scp|sftp)\s+(\S*)$') {
        $word = $Matches[2]
        $configPath = "$env:USERPROFILE\.ssh\config"
        if (Test-Path $configPath) {
            $hosts = @(
                Get-Content $configPath |
                    Where-Object { $_ -match '^\s*Host\s+' } |
                    ForEach-Object { ($_ -replace '^\s*Host\s+', '') -split '\s+' } |
                    Where-Object { $_ -notmatch '[\*\?]' -and $_ -like "$word*" }
            )
            if ($hosts.Count -gt 0) {
                $results = [System.Collections.ObjectModel.Collection[System.Management.Automation.CompletionResult]]::new()
                foreach ($h in $hosts) {
                    $results.Add(
                        [System.Management.Automation.CompletionResult]::new($h, $h, 'ParameterValue', $h)
                    )
                }
                return [System.Management.Automation.CommandCompletion]::new(
                    $results,
                    0,                              # currentMatchIndex
                    $cursorColumn - $word.Length,   # replacementIndex
                    $word.Length                    # replacementLength
                )
            }
        }
    }

    # 其它情况走原生补全
    & $global:__OrigTabExpansion2 $inputScript $cursorColumn $options
}
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
