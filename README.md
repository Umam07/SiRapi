# SiRapi

SiRapi adalah skrip PowerShell untuk merapikan file yang berantakan secara otomatis berdasarkan jenis dan ekstensi file.

SiRapi hanya memproses **file yang berada langsung di dalam folder pilihan**. Folder dan isi subfolder yang sudah ada tidak akan dipindahkan.

## Fitur

- Menu interaktif untuk memilih folder.
- Mode Standar dan Mode Pintar.
- Mode Preview untuk melihat rencana tanpa memindahkan file.
- Membuat folder kategori secara otomatis.
- Tidak pernah menimpa file yang sudah ada.
- Dapat melewati atau mengganti nama file duplikat.
- Menampilkan jumlah file dan total ukuran sebelum proses.
- Menampilkan hasil per kategori setelah proses selesai.
- Melewati file `SiRapi.ps1` miliknya sendiri.
- Menolak folder sistem seperti Windows, Program Files, AppData, dan root drive.
- Dapat dijalankan dari file lokal atau langsung dari GitHub.

## Persyaratan

- Windows 10 atau Windows 11.
- Windows PowerShell 5.1 atau PowerShell 7+.
- Jalankan menggunakan **PowerShell**, bukan Command Prompt atau CMD.

SiRapi tidak memerlukan instalasi aplikasi atau modul tambahan.

## Menjalankan File yang Sudah Diunduh

Misalnya, SiRapi disimpan di:

```text
D:\SiRapi\SiRapi.ps1
```

Buka PowerShell, kemudian jalankan:

```powershell
& "D:\SiRapi\SiRapi.ps1"
```

Tanda `&` digunakan PowerShell untuk menjalankan file skrip berdasarkan lokasinya.

### Jika Tidak Mengetahui Lokasi SiRapi

Cari `SiRapi.ps1` di folder Downloads:

```powershell
Get-ChildItem "$HOME\Downloads" -Filter "SiRapi.ps1" -Recurse -ErrorAction SilentlyContinue
```

Setelah lokasinya ditemukan, jalankan menggunakan lokasi lengkap. Contoh:

```powershell
& "C:\Users\NamaAnda\Downloads\SiRapi.ps1"
```

Lokasi yang mengandung spasi harus tetap ditulis di dalam tanda kutip.

## Menggunakan Menu Interaktif

Jalankan SiRapi tanpa parameter:

```powershell
& "D:\SiRapi\SiRapi.ps1"
```

SiRapi akan menampilkan pilihan folder:

```text
[1] Downloads
[2] Folder PowerShell saat ini
[3] Masukkan lokasi folder lain
```

- Pilih `1` untuk merapikan Downloads.
- Pilih `2` untuk merapikan folder aktif PowerShell.
- Pilih `3` untuk memasukkan lokasi folder secara manual.
- Tekan Enter tanpa memasukkan pilihan untuk memilih Downloads.

Setelah itu, pilih mode:

```text
[1] Pintar  - kategori lebih detail
[2] Standar - kategori sederhana
[3] Preview - lihat rencana tanpa memindahkan
```

Sebelum file dipindahkan, SiRapi akan menampilkan lokasi, jumlah file, total ukuran, dan meminta konfirmasi.

## Memilih Folder Secara Langsung

Gunakan parameter `-Path` agar tidak perlu memilih folder melalui menu:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads"
```

Contoh untuk folder lain:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "D:\Folder Saya"
```

> Mengetik `D:` hanya berpindah ke drive D, bukan ke folder `D:\SiRapi`. Gunakan `Set-Location "D:\SiRapi"` atau berikan lokasi lengkap menggunakan `-Path`.

## Mode Preview

Mode Preview menampilkan rencana pemindahan tanpa mengubah file apa pun.

Sangat disarankan menggunakan Preview sebelum merapikan folder penting:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced -Preview
```

Contoh hasil:

```text
[RENCANA] foto.jpg -> Images\Photos
[RENCANA] laporan.pdf -> Documents\PDF
[RENCANA] aplikasi.js -> Code
```

## Mode Standar

Mode Standar menggunakan kategori sederhana:

- `Images`
- `Videos`
- `Documents`
- `Applications`
- `Archives`
- `Audio`
- `Others`

Jalankan Mode Standar:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads"
```

## Mode Pintar

Mode Pintar menggunakan kategori yang lebih detail, antara lain:

- `Images\Photos`
- `Images\Graphics`
- `Documents\PDF`
- `Documents\Word`
- `Documents\Spreadsheets`
- `Documents\Presentations`
- `Documents\Text`
- `Applications\Installers`
- `Videos`
- `Audio`
- `Archives`
- `Code`
- `Data`
- `Books`
- `Fonts`
- `Others`

Jalankan Mode Pintar:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced
```

## Penanganan File Duplikat

Secara default, file dengan nama yang sama di folder tujuan akan dilewati:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -DuplicateAction Skip
```

Gunakan `Rename` agar file duplikat tetap dipindahkan menggunakan nama baru:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced -DuplicateAction Rename
```

Contoh nama baru:

```text
laporan.pdf
laporan (2).pdf
laporan (3).pdf
```

SiRapi tidak melakukan overwrite.

## Menjalankan Tanpa Konfirmasi

Parameter `-Yes` melewati pertanyaan konfirmasi sebelum proses dimulai:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced -Yes
```

Gunakan parameter ini hanya jika lokasi folder sudah dipastikan benar.

## Menjalankan Langsung dari GitHub

Ya, SiRapi dapat dijalankan langsung dari GitHub menggunakan `irm | iex` tanpa menyimpan file skrip.

Format URL Raw GitHub:

```text
https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1
```

Contoh perintah:

```powershell
irm "https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1" | iex
```

Perintah tersebut akan membuka menu interaktif SiRapi. Skrip dijalankan langsung dari memori dan tidak meninggalkan file `SiRapi.ps1` di folder pengguna.

Contoh `irm | iex` di atas paling mudah digunakan jika repository GitHub bersifat publik.

### Menjalankan Versi GitHub dengan Parameter

Untuk memberikan parameter kepada skrip online, buat script block secara langsung dalam satu baris:

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1"))) -Path "$HOME\Downloads" -Advanced -Preview
```

Setelah hasil Preview diperiksa, jalankan proses sebenarnya:

```powershell
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1"))) -Path "$HOME\Downloads" -Advanced -DuplicateAction Rename
```

## Catatan Keamanan untuk `irm | iex`

Perintah `irm | iex` mengunduh dan langsung menjalankan kode dari internet. Gunakan hanya URL repository yang dipercaya.

Untuk memeriksa isi skrip sebelum menjalankannya:

```powershell
irm "https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1"
```

Perintah di atas hanya menampilkan isi skrip dan tidak menjalankannya.

Cara yang lebih hati-hati adalah mengunduh skrip terlebih dahulu:

```powershell
Invoke-WebRequest "https://raw.githubusercontent.com/Umam07/SiRapi/main/SiRapi.ps1" -OutFile "$HOME\Downloads\SiRapi.ps1"
```

Kemudian periksa dan jalankan:

```powershell
& "$HOME\Downloads\SiRapi.ps1"
```

## Daftar Parameter

| Parameter | Keterangan |
|---|---|
| `-Path` | Menentukan folder yang akan dirapikan. |
| `-Advanced` | Mengaktifkan Mode Pintar dengan kategori lebih detail. |
| `-Preview` | Menampilkan rencana tanpa memindahkan file. |
| `-DuplicateAction Skip` | Melewati file jika nama yang sama sudah ada. Ini adalah nilai default. |
| `-DuplicateAction Rename` | Memindahkan duplikat menggunakan nama baru seperti `file (2).pdf`. |
| `-Yes` | Menjalankan proses tanpa pertanyaan konfirmasi. |

Parameter dapat digabungkan:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "D:\Folder Saya" -Advanced -DuplicateAction Rename -Yes
```

## Arti Status

| Status | Arti |
|---|---|
| `[RAPI!]` | File berhasil dipindahkan. |
| `[RENCANA]` | Rencana pemindahan dalam Mode Preview. |
| `[GANTI NAMA]` | File duplikat dipindahkan menggunakan nama baru. |
| `[DILEWATI]` | File tidak dipindahkan, biasanya karena nama yang sama sudah ada. |
| `[GAGAL]` | File gagal dipindahkan. |
| `[DIBATALKAN]` | Proses dibatalkan atau folder dilindungi. |
| `[BERSIH]` | Tidak ada file yang perlu dirapikan. |

## Mengatasi Masalah

### PowerShell Menolak Menjalankan Skrip

Jalankan SiRapi satu kali menggunakan Execution Policy Bypass:

```powershell
powershell -ExecutionPolicy Bypass -File "D:\SiRapi\SiRapi.ps1"
```

Atau buka blokir file yang telah diunduh:

```powershell
Unblock-File "D:\SiRapi\SiRapi.ps1"
```

### Folder Sistem Ditolak

SiRapi sengaja menolak folder seperti:

- `C:\Windows`
- `C:\Windows\System32`
- `C:\Program Files`
- `C:\ProgramData`
- Folder AppData
- Root drive seperti `C:\` atau `D:\`

Gunakan lokasi folder pengguna, misalnya:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads"
```

Jangan menjalankan SiRapi sebagai Administrator untuk memaksa pemindahan file sistem.

### Tidak Ada File yang Dipindahkan

SiRapi hanya memproses file yang berada langsung di folder pilihan. File yang sudah berada di dalam subfolder tidak diproses.

Gunakan Mode Preview untuk memastikan rencana:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "D:\Folder Saya" -Advanced -Preview
```

## Contoh Penggunaan yang Disarankan

Periksa Downloads tanpa memindahkan file:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced -Preview
```

Rapikan Downloads menggunakan kategori pintar:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "$HOME\Downloads" -Advanced
```

Rapikan folder dan ganti nama file duplikat:

```powershell
& "D:\SiRapi\SiRapi.ps1" -Path "D:\Folder Saya" -Advanced -DuplicateAction Rename
```

## Lisensi

Silakan gunakan, pelajari, dan kembangkan SiRapi sesuai kebutuhan.
