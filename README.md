# About

Use the [digitalxero/go-msi](https://github.com/digitalxero/go-msi) library to create a MSI package.

## Develop

Install [Chocolatey](https://chocolatey.org/install).

Install [MSYS2](https://community.chocolatey.org/packages/msys2), [Go](https://community.chocolatey.org/packages/go), and [LessMSI](https://github.com/activescott/lessmsi):

```batch
choco install -y msys2 --params="'/NoPath'"
choco install -y go
choco install -y lessmsi
winget install --exact --id MichalTrojnara.osslsigncode
```

To use the updated `PATH` environment variable, which will now include the
newly installed applications, exit the shell session, and open a new one.

Build the application, the example code signing certificate, and the unsigned and signed MSI:

```bash
go generate ./...
CGO_ENABLED=0 GOAMD64=v3 go build -trimpath -ldflags "-s -w"
./create-example-code-signing-certificate.sh
./use-go-msi.exe build-msi
```

Install the unsigned MSI:

```bash
lessmsi l -t _Tables use-go-msi-unsigned.msi
lessmsi l -t Property use-go-msi-unsigned.msi
lessmsi l -t Feature use-go-msi-unsigned.msi
lessmsi l -t FeatureComponents use-go-msi-unsigned.msi
lessmsi l -t Component use-go-msi-unsigned.msi
lessmsi l -t File use-go-msi-unsigned.msi
lessmsi l -t Icon use-go-msi-unsigned.msi
lessmsi l -t Directory use-go-msi-unsigned.msi
lessmsi l -t Shortcut use-go-msi-unsigned.msi
msiexec -i use-go-msi-unsigned.msi -qn -norestart '-l*v' install.log || echo "ERROR: $(cat install.log)"
find /c/Program\ Files/use-go-msi -type f
```

Uninstall with one of:

```bash
msiexec -x use-go-msi-unsigned.msi -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
msiexec -x '{401D679C-A1DF-4AD4-B7DC-E715471ADCE5}' -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
```

Install the signed MSI, show information about it, execute it, and finally uninstall it:

**NB** The signature verification will fail when your host does not trust the
`example-code-signing` CA.

```bash
lessmsi l -t _Tables use-go-msi.msi
lessmsi l -t Property use-go-msi.msi
lessmsi l -t Feature use-go-msi.msi
lessmsi l -t FeatureComponents use-go-msi.msi
lessmsi l -t Component use-go-msi.msi
lessmsi l -t File use-go-msi.msi
lessmsi l -t Icon use-go-msi.msi
lessmsi l -t Directory use-go-msi.msi
lessmsi l -t Shortcut use-go-msi.msi
osslsigncode verify -in use-go-msi.msi -CAfile example-code-signing-ca-crt.pem
pwsh -Command 'Import-Certificate example-code-signing-ca-crt.pem -CertStoreLocation Cert:/LocalMachine/Root'
pwsh -Command 'Get-AuthenticodeSignature use-go-msi.msi | Format-List'
msiexec -i use-go-msi.msi -qn -norestart '-l*v' install.log || echo "ERROR: $(cat install.log)"
find /c/Program\ Files/use-go-msi -type f
pwsh -Command 'Remove-Item -Path "Cert:/LocalMachine/Root/$(([System.Security.Cryptography.X509Certificates.X509Certificate2]::new([System.IO.File]::ReadAllBytes("example-code-signing-ca-crt.pem"))).Thumbprint)"'
```

Uninstall with one of:

```bash
msiexec -x use-go-msi.msi -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
msiexec -x '{401D679C-A1DF-4AD4-B7DC-E715471ADCE5}' -qn -norestart '-l*v' uninstall.log || echo "ERROR: $(cat uninstall.log)"
```

## References

* https://github.com/digitalxero/go-msi
* https://thesvg.org/icon/gopher
