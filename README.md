# SiRapi - Asisten Perapih Folder Otomatis

**SiRapi** adalah alat bantu pintar berbasis PowerShell untuk merapikan file-file yang berantakan di komputer Anda secara otomatis ke dalam subfolder berdasarkan jenis ekstensinya. 

SiRapi dirancang agar cepat, aman, dan **tidak akan menimpa file Anda yang sudah ada**.

---

## 🌟 Fitur Utama

* ⚡ **Rapi Seketika:** Mengelompokkan gambar, video, dokumen, aplikasi, arsip, dan audio ke folder kategorinya masing-masing.
* 🔒 **Bebas Timpa (Aman):** Jika ada file dengan nama yang sama di folder tujuan, SiRapi akan melewati atau mengganti namanya agar file lama Anda tidak hilang.
* 👁️ **Mode Preview (Simulasi):** Lihat rencana pemindahan file terlebih dahulu sebelum proses eksekusi dilakukan.
* 🧠 **Dua Pilihan Mode:**
  * **Standar:** Mengelompokkan ke kategori umum (Images, Videos, Documents, dll.).
  * **Pintar:** Kategori lebih spesifik (misal: memisahkan foto dari grafis/ikon, memisahkan dokumen PDF dari spreadsheet/Word).
* 🛡️ **Proteksi Folder Penting:** Mencegah ketidaksengajaan merapikan folder sistem seperti Windows, Program Files, AppData, atau root drive (seperti direktori `C:\` langsung).

---

## 🚀 Panduan Penggunaan (Tutorial)

Pilih salah satu dari 2 metode praktis berikut untuk mulai menggunakan SiRapi:

### Metode 1: Jalankan Langsung dari Internet (Rekomendasi - Paling Praktis)
Anda tidak perlu mengunduh file apa pun. Cukup salin perintah berikut dan jalankan langsung di PowerShell.

1. Buka **PowerShell** (Klik menu Start, ketik `PowerShell`, lalu klik/tekan Enter).
2. Salin dan tempel perintah satu baris di bawah ini, lalu tekan **Enter**:
   ```powershell
   irm "https://sirapi.itsumam.my.id/SiRapi.ps1" | iex
   ```
3. Menu pilihan interaktif akan muncul di layar. Cukup ikuti instruksi angka untuk memilih folder dan mode yang diinginkan.

---

### Metode 2: Download Skrip dan Jalankan secara Lokal
Gunakan metode ini jika Anda ingin mengunduh file skripnya terlebih dahulu ke komputer Anda.

1. **Unduh File Skrip:**
   Unduh file `SiRapi.ps1` dan simpan di folder komputer Anda (misalnya di `D:\SiRapi`).
2. **Arahkan PowerShell ke Folder Tersebut:**
   Buka PowerShell, lalu jalankan perintah berikut untuk berpindah lokasi ke folder tempat skrip disimpan:
   ```powershell
   d:
   cd "D:\SiRapi"
   ```
3. **Buka Blokir Keamanan Windows (Wajib Pertama Kali):**
   Agar Windows mengizinkan skrip yang diunduh untuk berjalan, lakukan pembukaan blokir sekali saja:
   ```powershell
   Unblock-File .\SiRapi.ps1
   ```
4. **Jalankan Skrip:**
   ```powershell
   .\SiRapi.ps1
   ```

---

## 💡 Informasi Tambahan (Untuk Pengguna Lanjut)

### Menjalankan dengan Parameter Langsung
Anda dapat melewati menu pilihan interaktif dengan memberikan parameter langsung di terminal PowerShell:

* **Merapikan folder tertentu secara langsung:**
  ```powershell
  & "D:\SiRapi\SiRapi.ps1" -Path "D:\Nama Folder Anda"
  ```
* **Melihat simulasi (Preview) folder tertentu:**
  ```powershell
  & "D:\SiRapi\SiRapi.ps1" -Path "D:\Nama Folder Anda" -Preview
  ```
* **Merapikan folder dan otomatis memberi nama baru untuk file duplikat:**
  ```powershell
  & "D:\SiRapi\SiRapi.ps1" -Path "D:\Nama Folder Anda" -DuplicateAction Rename
  ```

### Keamanan & Aturan Perapihan
* **Folder Sistem Ditolak:** SiRapi secara otomatis menolak/membatalkan proses jika Anda memilih folder sistem atau folder aplikasi yang dilindungi demi keamanan komputer Anda, seperti:
  * `C:\Windows` atau `C:\Windows\System32`
  * `C:\Program Files` atau `C:\Program Files (x86)`
  * `C:\ProgramData`
  * Folder `AppData` (baik `Local` maupun `Roaming`)
  * Root drive utama langsung (seperti `C:\` atau `D:\`)
* **Hanya Memproses File Utama:** SiRapi hanya merapikan file yang berada langsung di dalam folder target. Folder atau file di dalam subfolder yang sudah ada tidak akan diotak-atik.

### Arti Status Proses
Berikut penjelasan label status yang muncul di layar saat SiRapi sedang bekerja:

| Status | Penjelasan |
|---|---|
| **`[RAPI!]`** | File berhasil dipindahkan ke folder kategori. |
| **`[RENCANA]`** | Rencana pemindahan file (hanya muncul di Mode Preview). |
| **`[GANTI NAMA]`** | Nama file diubah otomatis karena ada file duplikat di tujuan (misal: `file (2).pdf`). |
| **`[DILEWATI]`** | File dilewati karena sudah ada file dengan nama yang sama di folder tujuan. |
| **`[GAGAL]`** | File gagal dipindahkan (misalnya karena file sedang dibuka oleh program lain). |
| **`[DIBATALKAN]`**| Proses dibatalkan oleh pengguna, atau karena folder dilindungi. |
| **`[BERSIH]`** | Tidak ada file yang perlu dirapikan di folder tersebut. |

---

## 📄 Lisensi
Silakan gunakan, pelajari, modifikasi, dan bagikan SiRapi secara bebas sesuai kebutuhan Anda!
