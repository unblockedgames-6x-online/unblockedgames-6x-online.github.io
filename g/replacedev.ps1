# developer list file
$devFile = "devlist.txt"

# mapping load
$map = @{}
Get-Content $devFile | ForEach-Object {
    if ($_ -match "^(.*?)\s+(.*)$") {
        $name = $matches[1].Trim()
        $dev  = $matches[2].Trim()
        $map[$name] = $dev
    }
}

Get-ChildItem -Directory | ForEach-Object {

    $folder = $_.Name
    $index = Join-Path $_.FullName "index.html"

    if (!(Test-Path $index)) { return }

    $html = Get-Content $index -Raw

    if ($map.ContainsKey($folder)) {

        $devName = $map[$folder]

        # sirf span ke andar replace karo (safe)
        $html = $html -replace '(<span class="_Vo7p3ZHOD37kAhG3YNE">by )coming-soon(</span>)', "`$1$devName`$2"

        Set-Content $index $html -Encoding UTF8

        Write-Host "Updated: $folder → $devName"
    }
    else {
        Write-Host "No dev found: $folder"
    }
}