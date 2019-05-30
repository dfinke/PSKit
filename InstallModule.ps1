$fullPath = 'C:\Program Files\WindowsPowerShell\Modules\PSKit'

Robocopy . $fullPath /mir /XD .vscode .git examples data /XF appveyor.yml azure-pipelines.yml .gitattributes .gitignore