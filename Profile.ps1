function prompt {
    # Precalculate ANSI color codes with original RGB values
    $reset = "`e[0m"
    $teal = "`e[38;2;0;184;147m"
    $blue = "`e[38;2;12;160;216m"
    $green = "`e[38;2;20;165;174m"
    $red = "`e[38;2;243;79;41m"
    $pink = "`e[38;2;255;105;180m"
    $yellow = "`e[38;2;247;236;36m"

    # Cache username and home path - don't compute it every time prompt runs
    if (-not $script:cachedUser) {
        $script:cachedUser = [Environment]::UserName
        # Cache the home directory with forward slashes for consistent comparison
        $script:homeDir = $HOME.Replace('\', '/')
        $script:userDisplay = "$teal󰀉 $script:cachedUser$reset"
        $script:onText = "$yellow on $reset"
        $script:homeSymbol = "󰉋  ~"
    }
    
    # Get current path (Unix-style) with forward slashes
    $curPath = $PWD.Path.Replace('\', '/')
    
    # Replace home directory path with custom home symbol
    if ($curPath.StartsWith($script:homeDir, [StringComparison]::OrdinalIgnoreCase)) {
        if ($curPath.Length -eq $script:homeDir.Length) {
            # If exactly at home directory
            $curPath = $script:homeSymbol
        } else {
            # If in a subdirectory of home
            $curPath = $script:homeSymbol + $curPath.Substring($script:homeDir.Length)
        }
    }
    
    # Use Join method instead of StringBuilder for better performance with small strings
    $promptText = [string]::Join('', @(
        $script:userDisplay,
        $script:onText,
        "$blue$curPath$reset "
    ))
    
    # Git operations are expensive - check for .git directory first
    if (Test-Path -Path ".git" -PathType Container) {
        $gitBranch = & git -c color.ui=false branch --show-current 2>$null
        
        if ($gitBranch) {
            $promptText += "$red ($reset$green$gitBranch$reset$red)$reset"
            
            # Only check stash if we're in a git repo and branch exists
            $stashCount = & git -c color.ui=false stash list 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines
            if ($stashCount -gt 0) {
                $promptText += " $yellow⚑$stashCount$reset"
            }
        }
    }
    
    # Append newline and prompt character using string concatenation (faster for small strings)
    $promptText + "`n$pink`$$reset "
}
