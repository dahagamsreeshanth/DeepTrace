# DeepTrace Upstream Sync Script
# Syncs local repository and origin fork with upstream source (nrk-boolean/HackVibe2)

Write-Host "Fetching latest updates from upstream (nrk-boolean/HackVibe2)..." -ForegroundColor Cyan
git fetch upstream

$localHead = (git rev-parse HEAD).Trim()
$upstreamHead = (git rev-parse upstream/main).Trim()

if ($localHead -eq $upstreamHead) {
    Write-Host "Code is already up to date with upstream/main ($localHead)." -ForegroundColor Green
} else {
    Write-Host "New commits detected on upstream/main. Resetting transient files and merging into main..." -ForegroundColor Yellow
    
    # Restore runtime-modified stats file to prevent merge conflicts
    git checkout -- orchestrator/stats.json 2>$null
    
    # Merge upstream changes
    git merge upstream/main --no-edit
    
    # Push to origin fork
    Write-Host "Pushing merged changes to your fork (origin/main)..." -ForegroundColor Cyan
    git push origin main
    
    $newHead = (git rev-parse --short HEAD).Trim()
    Write-Host "Successfully updated to commit $newHead!" -ForegroundColor Green
}
