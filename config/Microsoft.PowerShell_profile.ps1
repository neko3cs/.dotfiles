#Requires -PSEdition Core

$PowerShellModules = @(
    "posh-git"
    "Pester"
    "powershell-yaml"
    "SqlServer"
    "ClassExplorer"
    "ImportExcel"
)
function Register-PowerShellModule {
    foreach ($module in $PowerShellModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Install-Module -Name $module
        }
        if (-not (Get-Module -Name $module)) {
            Import-Module -Name $module
        }
    }
}
function Register-WingetCompletion {
    if (Get-Command winget -ea SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
            [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
            $Local:word = $wordToComplete.Replace('"', '""')
            $Local:ast = $commandAst.ToString().Replace('"', '""')
            winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
}
function Register-DotNetCompletion {
    if (Get-Command dotnet -ea SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
            param($commandName, $wordToComplete, $cursorPosition)
            dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }
}
function Register-AzureCliCompletion {
    Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
        $completion_file = New-TemporaryFile
        $env:ARGCOMPLETE_USE_TEMPFILES = 1
        $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
        $env:COMP_LINE = $wordToComplete
        $env:COMP_POINT = $cursorPosition
        $env:_ARGCOMPLETE = 1
        $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
        $env:_ARGCOMPLETE_IFS = "`n"
        $env:_ARGCOMPLETE_SHELL = 'powershell'
        az 2>&1 | Out-Null
        Get-Content $completion_file | Sort-Object | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
        }
        Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
    }
}
function Register-OhMyPoshSettings {
    oh-my-posh init pwsh `
        --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/stelbent.minimal.omp.json' | 
    Invoke-Expression
}

# Windows Only
if ($IsWindows) {
    Register-WingetCompletion

    ## Environment Variables
    $Env:JAVA_HOME = "$HOME\AppData\Local\Programs\Microsoft\jdk-17.0.10.7-hotspot"
    $Env:ANDROID_HOME = "$HOME\AppData\Local\Android\Sdk"
    ## Alias
    Set-Alias -Name open -Value 'explorer.exe'
    Set-Alias -Name lg -Value 'lazygit.exe'
    Set-Alias -Name jq -Value 'jq-win64.exe'
    Set-Alias -Name winmerge -Value "$HOME\AppData\Local\Programs\WinMerge\WinMergeU.exe"
    function zsh {
        wsl /usr/bin/zsh
    }
    function which {
        param(
            [parameter(Mandatory, ValueFromPipeline)][string]$command
        )
        return (Get-Command -Name $command -ShowCommandInfo).Definition
    }
}

# All Platform
Register-PowerShellModule
Register-OhMyPoshSettings
Register-DotNetCompletion
Register-AzureCliCompletion

# PowerShell Customize
Set-PSReadLineOption `
    -PredictionSource History `
    -PredictionViewStyle ListView

## Alias
Set-Alias -Name ll -Value Get-ChildItem
function lla {
    Get-ChildItem -Force
}
Set-Alias -Name touch -Value New-Item
