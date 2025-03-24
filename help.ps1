Write-Host " install:" -ForegroundColor Cyan -NoNewline
Write-Host "  Install missing dependencies. Runs `go mod tidy`."
Write-Host " run:" -ForegroundColor Cyan -NoNewline
Write-Host "      Run the server."
Write-Host " stop:" -ForegroundColor Cyan -NoNewline
Write-Host "     Stop the server."
Write-Host " restart:" -ForegroundColor Cyan -NoNewline
Write-Host "  Restart the server."
Write-Host " compile:" -ForegroundColor Cyan -NoNewline
Write-Host "  Compile the app."
Write-Host " clean:" -ForegroundColor Cyan -NoNewline
Write-Host "    Clean the cache."
Write-Host " help:" -ForegroundColor Cyan -NoNewline
Write-Host "     Show the commands."
Write-Host " test:" -ForegroundColor Cyan -NoNewline
Write-Host "     Run the test container: docker compose -f docker-compose.test.yml up -d."
Write-Host " build:" -ForegroundColor Cyan -NoNewline
Write-Host "    Build the docker container."
Write-Host " up:" -ForegroundColor Cyan -NoNewline
Write-Host "       Run the docker container."
Write-Host " down:" -ForegroundColor Cyan -NoNewline
Write-Host "     Stop the docker container."
