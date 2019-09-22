#
# Manifesto per il modulo 'Poshstache'
#
# Generato da: Marco Torello
#
# Generato in data: 26/07/2017
#

@{

# File del modulo di script o del modulo binario associato a questo manifesto.
RootModule = 'Poshstache.psm1'

# Numero di versione del modulo.
ModuleVersion = '0.1.3'

# Edizioni di PS supportate
# CompatiblePSEditions = @()

# ID utilizzato per identificare in modo univoco il modulo
GUID = 'e8382377-7e6b-443e-8d1a-b9f8d877ba7d'

# Autore del modulo
Author = 'Marco Torello'

# Società o fornitore del modulo
CompanyName = 'Sconosciuto'

# Informazioni sul copyright per il modulo
Copyright = '(c) 2019 Marco Torello. All rights reserved.'

# Descrizione delle funzionalità offerte dal modulo
Description = 'A Powershell implementation of Mustache based on Stubble'

# Versione minima del motore di Windows PowerShell necessaria per il modulo
# PowerShellVersion = ''

# Nome dell'host di Windows PowerShell richiesto dal modulo
# PowerShellHostName = ''

# Versione minima dell'host di Windows PowerShell richiesta dal modulo
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. Questo prerequisito è valido solo per l'edizione Desktop di PowerShell.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. Questo prerequisito è valido solo per l'edizione Desktop di PowerShell.
# CLRVersion = ''

# Architettura del processore (None, X86, Amd64, IA64) richiesta dal modulo
# ProcessorArchitecture = ''

# Moduli che devono essere importati nell'ambiente globale prima di importare il modulo
# RequiredModules = @()

# Assembly che devono essere caricati prima di importare il modulo
# RequiredAssemblies = @()

# File script (ps1) eseguiti nell'ambiente del chiamante prima di importare il modulo.
# ScriptsToProcess = @()

# File di tipi (ps1xml) da caricare al momento dell'importazione del modulo
# TypesToProcess = @()

# File di formato (ps1xml) da caricare al momento dell'importazione del modulo
# FormatsToProcess = @()

# Moduli da importare come moduli annidati del modulo specificato in RootModule/ModuleToProcess
# NestedModules = @()

# Funzioni da esportare dal modulo. Per ottenere prestazioni ottimali, non usare caratteri jolly e non eliminare la voce. Usare una matrice vuota se non sono presenti funzioni da esportare.
FunctionsToExport = 'ConvertTo-PoshstacheTemplate'

# Cmdlet da esportare dal modulo. Per ottenere prestazioni ottimali, non usare caratteri jolly e non eliminare la voce. Usare una matrice vuota se non sono presenti cmdlet da esportare.
CmdletsToExport = ''

# Variabili da esportare dal modulo
VariablesToExport = ''

# Alias da esportare dal modulo. Per ottenere prestazioni ottimali, non usare caratteri jolly e non eliminare la voce. Usare una matrice vuota se non sono presenti alias da esportare.
AliasesToExport = ''

# Risorse DSC da esportare da questo modulo
# DscResourcesToExport = @()

# Elenco di tutti i moduli inclusi nel modulo
# ModuleList = @()

# Elenco di tutti i file inclusi nel modulo
# FileList = @()

# Dati privati da passare al modulo specificato in RootModule/ModuleToProcess. Può inoltre includere una tabella hash PSData con altri metadati del modulo utilizzati da PowerShell.
PrivateData = @{

    PSData = @{

        # Tag applicati al modulo per semplificarne l'individuazione nelle raccolte online.
        Tags = @("Mustache","LogicLessTemplate","HTML","Templating","Template")

        # URL della licenza di questo modulo.
        LicenseUri = 'https://github.com/baldator/Poshstache/blob/master/LICENSE.txt'

        # URL del sito Web principale per questo progetto.
        ProjectUri = 'https://github.com/baldator/Poshstache'

        # URL di un'icona che rappresenta questo modulo.
        # IconUri = ''

        # Note sulla versione di questo modulo
        ReleaseNotes = @"
    v 0.1.3 - Replace Nustache with Stubble
    v 0.1.2 - Bugfix
    v 0.1.1 - Add Pester tests
    v 0.1.0 - First release
"@

    } # Fine della tabella hash PSData

} # Fine della tabella hash PrivateData

# URI HelpInfo del modulo
# HelpInfoURI = ''

# Prefisso predefinito per i comandi esportati da questo modulo. Per sostituire il prefisso predefinito, utilizzare Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

