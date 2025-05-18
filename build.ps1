$ErrorActionPreference = 'Stop'

# Read .env file into environment variables
if (Test-Path .env -PathType Leaf) {
    Get-Content .env | ForEach-Object {
        $name, $value = $_.split('=')
        Set-Item env:$name -Value $value
    }
}

Remove-Item .\build\PDFEpf -Recurse -ErrorAction SilentlyContinue
Copy-Item .\PDFEpf .\build\PDFEpf -Recurse

# Copy over the template files
New-Item .\build\PDFEpf\PDFEpf\Templates\АрхивРесурсов\Ext -ItemType Directory
Copy-Item .\build\resources.zip .\build\PDFEpf\PDFEpf\Templates\АрхивРесурсов\Ext\Template.bin -Force

New-Item .\build\PDFEpf\PDFEpf\Templates\ДокументPDF\Ext -ItemType Directory
Copy-Item .\build\sample.pdf .\build\PDFEpf\PDFEpf\Templates\ДокументPDF\Ext\Template.bin -Force

# Build the epf
$designer = Start-Process "${env:1C_HOME}\bin\1cv8.exe" "DESIGNER /LoadExternalDataProcessorOrReportFromFiles .\build\PDFEpf\PDFEpf.xml .\build\PDF.epf" -PassThru -Wait
if ($designer.ExitCode -ne 0) {
	throw "Error building epf!";
}
