# wifipass

Bağlı olduğun Wi-Fi ağının adını, şifresini ve güvenlik bilgilerini gösterir.  
Shows your connected Wi-Fi network name, password and security info.

## Kullanım / Usage

PowerShell'i aç ve yapıştır:  
Open PowerShell and paste:

```powershell
irm bit.ly/wifipassps1 | iex
```

Dil seçeneği çıkar → `1` Türkçe, `2` İngilizce.  
Language prompt appears → `1` Turkish, `2` English.

## Örnek çıktı / Example output

```
  Dil secin / Choose language:
    [1] Turkce
    [2] English

  >> 1

  ================================
    Wi-Fi Bilgileri
  ================================
  Ag adi    : MyHomeNetwork
  Sifre     : gizlisifre123
  Guvenlik  : WPA2-Personal
  Sinyal    : 78%
```

## Gereksinimler / Requirements

- Windows 10 / 11
- PowerShell 5.1+
