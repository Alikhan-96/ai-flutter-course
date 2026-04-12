flutter test --coverage

if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

$coverageFile = Join-Path $PSScriptRoot "..\\coverage\\lcov.info"
$criticalFiles = @(
  "lib/data/dto/task_dto.dart",
  "lib/data/mappers/task_mapper.dart",
  "lib/domain/usecases/add_task_usecase.dart"
)

if (-not (Test-Path $coverageFile)) {
  Write-Error "Coverage file was not generated: $coverageFile"
  exit 1
}

$coverageContent = Get-Content -Raw $coverageFile
$missingFiles = @()

foreach ($file in $criticalFiles) {
  if ($coverageContent -notmatch [regex]::Escape($file)) {
    $missingFiles += $file
  }
}

if ($missingFiles.Count -gt 0) {
  Write-Error ("Coverage is missing critical files: " + ($missingFiles -join ", "))
  exit 1
}

Write-Host "Coverage generated successfully: $coverageFile"
Write-Host "Critical lesson files are present in the coverage report."
