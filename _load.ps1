

    # Install module, but do not import
    Install-Module -ModuleName 'Rick.Sammons' -ModulePath '.\source' -Update -Global -DoNotImport

    # Import module with specific version and skip name checking
    Import-Module 'Rick.Sammons' -Force -DisableNameChecking 


