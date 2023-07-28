# Written by: Michael Glassman (7/26/2023)
# Purpose: Convert PDF file into Assorted PNG files (W/ Transparency)
# Replace with your input PDF file path and output directory for images
$sourcePdfFile = "Change Me EX C:\Set\To\Folder\Filename"
$outputDirectory = "Change Me EX C:\Set\To\Folder"

# Check if Ghostscript is installed *I installed Version 10.01.2 | Rename this to your Version
if (-Not (Test-Path (Join-Path $env:ProgramFiles 'gs\gs10.01.2\bin\gswin64c.exe'))) {
    Write-Host "Ghostscript is not installed or the path is incorrect."
    Write-Host "Please install Ghostscript and try again."
    exit
}

# Create the output directory if it doesn't exist
if (-Not (Test-Path $outputDirectory)) {
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
}

# Use Ghostscript to convert the PDF to images
$arguments = @(
    "-q",                         # Quiet mode
    "-dSAFER",                    # Enable a safer mode
    "-dBATCH",                    # Batch mode
    "-dNOPAUSE",                  # Don't pause between pages
    "-sDEVICE=pngalpha",          # Set the output device to PNG with alpha channel support
    "-r300",                      # Set the resolution to 300 DPI (adjust as needed)
    "-dTextAlphaBits=4",          # Improve text output
    "-dGraphicsAlphaBits=4",      # Improve graphics output
    "-sOutputFile=$outputDirectory\output_%03d.png",  # Output file name pattern
    "$sourcePdfFile"              # Source PDF file
)

$gsProcess = Start-Process -FilePath (Join-Path $env:ProgramFiles 'gs\gs10.01.2\bin\gswin64c.exe') -ArgumentList $arguments -NoNewWindow -PassThru

# Wait for Ghostscript to finish
$gsProcess.WaitForExit()

Write-Host "PDF conversion completed successfully."
