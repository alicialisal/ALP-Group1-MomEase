# Momease  

Momease adalah aplikasi yang dirancang untuk mendukung kesehatan mental para ibu, khususnya ibu hamil dan pasca melahirkan yang mengalami **baby blues syndrome**. Aplikasi ini bertujuan membantu para ibu mengelola emosi, mengurangi stres, dan mendukung kesejahteraan mental mereka melalui fitur-fitur inovatif.  

## Fitur Utama  
1. **Mood Journaling**  
   - Membantu pengguna mencatat suasana hati harian dengan ikon unik untuk memahami pola emosi dan memantau perubahan suasana hati.  

2. **Chatbot AI**  
   - Teman cerita yang mendengarkan keluhan dan memberikan respons emosional yang mendukung. Dikembangkan menggunakan **API Gemini**.  

3. **Kegiatan Relaksasi**  
   - Menawarkan berbagai aktivitas untuk menurunkan stres, dilengkapi filter kategori dan durasi untuk memudahkan pencarian.  

4. **Blog Edukasi**  
   - Menyediakan artikel tentang manajemen emosi dan tips parenting untuk membantu ibu meningkatkan pemahaman mereka.  

## Teknologi yang Digunakan  
- **Frontend**: Flutter  
- **Backend**: Laravel  
- **API**: API Gemini untuk pengembangan Chatbot AI
- **Database**: MySQL

## Cara Instalasi  
1. Clone repositori ini:  
   ```bash
   git clone https://github.com/username/momease.git
   cd momease
   ```  
2. Install dependensi backend Laravel:  
   ```bash
   composer install
   ```  
3. Install dependensi frontend Flutter:  
   ```bash
   flutter pub get
   ```  
4. Atur file konfigurasi:  
   - Backend: `.env`  
   - Frontend: Sesuaikan konfigurasi API endpoint pada file `lib/config/api_config.dart`.  

5. Jalankan backend server Laravel:  
   ```bash
   php artisan serve
   ```  

6. Jalankan aplikasi Flutter:  
   ```bash
   flutter run
   ```  
