$email="billheughan@gmail.com"
$username="amazinghorse"
$gpgkeyid="EF3CFB2BBEB6069A"

if (((Get-Command winget -ErrorAction SilentlyContinue))) {
    echo "winget installed."
} else { 
    echo "Installing winget..."
    function InstallWinGet()
    {
        $hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"

        if(!$hasPackageManager)
        {
            Add-AppxPackage -Path "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
            
            $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $releases = Invoke-RestMethod -uri "$($releases_url)"
            $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith("msixbundle") } | Select -First 1
        
            Add-AppxPackage -Path $latestRelease.browser_download_url
        }
    }
    InstallWinGet
}
if (Get-Command gsudo -ErrorAction SilentlyContinue) {
    echo "sudo exists"
} else {
    winget install gerardog.gsudo
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    echo "git exists"
} else { 
    echo "Installing git..."
    winget install Git.Git
    winget install GnuPG.Gpg4win
    # Configure Git
    git config --global user.email "${email}"
    git config --global user.name "${username}"
    git config --global user.signingkey "${gpgkeyid}"
    git config --global commit.gpgsign true
    git config gpg.program (get-command gpg).path
    #git config --global core.pager /usr/bin/less
    git config --global core.excludesfile ~/.gitignore
}
if (Get-Command ssh -ErrorAction SilentlyContinue) {
    echo "ssh exists"
} else { 
    winget install PuTTY.PuTTY
    gsudo Set-Service ssh-agent -StartupType Automatic
}
    # Generate a new SSH key
    ssh-keygen -t rsa -b 4096 -C "${email}"

    # Start ssh-agent and add the key to it
    ssh-add ~/.ssh/id_rsa
    echo "---- COPY BELOW ----"
    # Display the public key ready to be copy pasted to GitHub
    cat ~/.ssh/id_rsa.pub 
    echo "---- COPY ABOVE ----"
    mkdir -p ~\dev\dotfiles
    git clone git@github.com:amazinghorse/dotfiles.git $env:USERPROFILE/dev/dotfiles
    winget install GitHub.cli
    
echo "Finished Components install."