# 🌱 Mandar Eco-Run

**Mandar Eco-Run** adalah game **2D Endless Runner bertema lingkungan** yang dikembangkan menggunakan **Godot Engine 4.7**. Game ini menggabungkan mekanik berlari tanpa batas, menghindari sampah, mengumpulkan sampah yang dapat memberikan poin, sistem nyawa, peningkatan tingkat kesulitan, checkpoint, serta mini-game pemilahan sampah.

Game dirancang tidak hanya sebagai permainan arcade sederhana, tetapi juga membawa konsep **kepedulian terhadap lingkungan dan pengelolaan sampah**. Pemain berperan sebagai karakter yang berlari melewati lingkungan yang dipenuhi berbagai jenis sampah. Pemain harus mampu menghindari sampah berbahaya sekaligus mengumpulkan sampah tertentu untuk memperoleh skor.

---

## 🎮 Informasi Game

| Informasi | Detail |
|---|---|
| **Nama Game** | Mandar Eco-Run |
| **Genre** | 2D Endless Runner |
| **Tema** | Lingkungan / Kebersihan / Pengelolaan Sampah |
| **Engine** | Godot Engine 4.7 |
| **Bahasa Pemrograman** | GDScript |
| **Platform** | Desktop / Mobile-ready |
| **Rendering** | Mobile Renderer |
| **Arsitektur** | Scene-Based Architecture |
| **Physics** | Godot Physics / Jolt Physics configuration |
| **Game Mode** | Endless Run + Waste Sorting Mini-game |

---

# 📖 Deskripsi Game

Dalam **Mandar Eco-Run**, pemain mengendalikan seorang karakter yang terus bergerak melewati lingkungan yang penuh dengan berbagai jenis sampah.

Pemain tidak mengontrol gerakan horizontal karakter utama. Karakter akan berada pada jalur permainan dan dunia bergerak menuju pemain. Tugas utama pemain adalah mengatur waktu lompatan agar karakter tidak terkena sampah berbahaya.

Selama perjalanan, pemain akan menemukan dua jenis objek utama:

- 🗑️ **Sampah berbahaya** yang harus dihindari.
- ♻️ **Sampah yang dapat dikumpulkan** untuk mendapatkan tambahan skor.

Semakin jauh pemain berlari, permainan akan menjadi semakin cepat. Hal ini membuat pemain harus memiliki reaksi yang semakin baik.

Pada jarak tertentu, pemain juga akan menemukan **checkpoint**. Checkpoint memberikan kesempatan kepada pemain untuk mengikuti mini-game pemilahan sampah.

---

# 🎯 Tujuan Permainan

Tujuan utama pemain adalah:

1. Berlari sejauh mungkin.
2. Menghindari sampah berbahaya.
3. Mengumpulkan sampah yang memberikan poin.
4. Mempertahankan seluruh nyawa selama mungkin.
5. Mencapai checkpoint.
6. Menyelesaikan mini-game pemilahan sampah.
7. Mendapatkan bonus dari mini-game.
8. Mendapatkan skor setinggi mungkin.
9. Mencatat skor pada leaderboard.

Dengan demikian, permainan memiliki dua tujuan utama:

> **Bertahan selama mungkin dan memperoleh skor setinggi mungkin.**

---

# 🕹️ Kontrol

## Game Utama

| Tombol | Fungsi |
|---|---|
| `Space` / `ui_accept` | Melompat |
| Menahan `Space` | Melakukan lompatan lebih tinggi |
| Melepas `Space` lebih cepat | Memperpendek lompatan |

Karakter tidak menggunakan kontrol kiri-kanan pada mode utama karena karakter berjalan secara otomatis.

## Mini-game

| Tombol | Fungsi |
|---|---|
| `←` | Bergerak ke kiri |
| `→` | Bergerak ke kanan |

Pada mini-game, pemain mengendalikan tempat sampah/catcher untuk menangkap sampah yang jatuh.

---

# 🧩 Mekanik Gameplay

## 1. Endless Runner

Gameplay utama menggunakan konsep **endless runner**.

Tidak terdapat garis finish tetap. Permainan terus berlangsung selama pemain masih memiliki nyawa.

Dunia permainan bergerak secara horizontal menggunakan kecepatan global:

```text
START_SPEED = 300
MAX_SPEED   = 500
```

Kecepatan permainan meningkat secara bertahap selama permainan berlangsung.

Pada setiap frame:

```text
speed = speed + 10 × delta
```

Namun kecepatan dibatasi hingga:

```text
MAX_SPEED = 500
```

Akibatnya, semakin lama pemain bertahan, semakin cepat objek dan platform bergerak.

---

# 🏃 Mekanik Karakter

Karakter utama menggunakan:

```text
CharacterBody2D
```

dan dikendalikan oleh script:

```text
Script/player.gd
```

Karakter memiliki dua kondisi animasi utama:

```text
idle
lari
```

Ketika permainan belum dimulai:

```text
idle
```

Ketika permainan berjalan:

```text
lari
```

---

## 🦘 Mekanik Lompat

Karakter menggunakan sistem gravitasi dan velocity.

Parameter utama:

```text
JUMP_VELOCITY = -1200
GRAVITY       = 2500
```

Ketika pemain menekan tombol lompat dan karakter sedang berada di lantai:

```text
velocity.y = -1200
```

Karakter kemudian ditarik kembali ke bawah oleh gravitasi.

---

## 🪶 Variable Jump

Game menggunakan mekanik **variable jump height**.

Jika tombol lompat dilepas ketika karakter masih bergerak ke atas, velocity vertikal akan dikurangi:

```text
velocity.y *= 0.8
```

Artinya:

- Menahan tombol lebih lama → lompatan lebih tinggi.
- Melepas tombol lebih cepat → lompatan lebih pendek.

Mekanik ini membuat kontrol karakter terasa lebih responsif dibandingkan lompatan dengan tinggi tetap.

---

# 🗑️ Sistem Sampah

Sampah pada mode utama dibagi menjadi dua kategori utama.

## ☠️ Sampah Berbahaya

Sampah berbahaya berfungsi sebagai obstacle.

Beberapa scene yang tersedia:

```text
sampah_kimia.tscn
sampah_berbahaya_udara.tscn
```

Object tersebut dimasukkan ke group:

```text
sampah_hit
```

Ketika karakter menyentuh object dengan group tersebut, karakter kehilangan satu nyawa.

---

## ♻️ Sampah Penghasil Poin

Selain obstacle, terdapat sampah yang dapat dikumpulkan.

Contohnya:

```text
sampah_organik_1.tscn
sampah_plastik_1.tscn
```

Object yang memberikan poin dimasukkan ke group:

```text
sampah_poin
```

Ketika pemain menyentuhnya:

```text
+10 Score
```

Setelah dikumpulkan, object tersebut dihapus dari scene.

---

# ❤️ Sistem Nyawa

Pemain memiliki:

```text
MAX_HEARTS = 3
```

Artinya setiap permainan dimulai dengan **3 nyawa**.

Ketika terkena sampah berbahaya:

```text
hearts -= 1
```

HUD kemudian memperbarui tampilan jumlah nyawa.

Contohnya:

```text
❤️ ❤️ ❤️
```

menjadi:

```text
❤️ ❤️
```

kemudian:

```text
❤️
```

dan akhirnya:

```text
0 nyawa
```

Ketika nyawa mencapai 0, permainan berakhir.

---

# 🛡️ Sistem Invulnerability

Setelah terkena obstacle, pemain tidak langsung dapat terkena damage berulang kali.

Game mengaktifkan:

```text
is_invulnerable = true
```

Selama sekitar:

```text
1 detik
```

Karakter dibuat transparan sebagian:

```text
modulate.a = 0.5
```

Setelah periode tersebut selesai:

```text
modulate.a = 1.0
is_invulnerable = false
```

Mekanisme ini mencegah satu tabrakan menghasilkan kehilangan banyak nyawa sekaligus.

---

# 🧱 Sistem Platform

Arena menggunakan sistem platform yang bergerak dari kanan ke kiri.

Platform dikendalikan oleh:

```text
platform.gd
```

Setiap platform bergerak berdasarkan:

```text
position.x -= GameManager.speed * delta
```

Dengan demikian, platform mengikuti kecepatan permainan global.

---

# 🔄 Platform Spawner

Platform baru dibuat secara dinamis menggunakan:

```text
platform_spawner.gd
```

Spawner menyimpan jarak yang sudah ditempuh:

```text
distance_storage
```

Setiap kali jarak mencapai:

```text
spawn_distance = 500
```

platform baru akan dibuat.

Jenis platform dipilih secara acak dari:

```text
platforms.pick_random()
```

Hal ini membuat arena dapat terus dibuat tanpa batas.

---

# 🌍 Background Parallax

Background menggunakan:

```text
ParallaxBackground
```

dan script:

```text
background.gd
```

Background bergerak berdasarkan kecepatan permainan:

```text
scroll_base_offset.x -= GameManager.speed * speed_multiplier * delta
```

Dengan:

```text
speed_multiplier = 0.8
```

Efek ini menghasilkan **parallax scrolling**, sehingga latar belakang tampak bergerak mengikuti perjalanan karakter.

---

# 🗑️ Sampah Spawner

Obstacle dan sampah penghasil poin dibuat menggunakan:

```text
sampah_spawner.gd
```

Spawner mempunyai dua kategori:

```text
bahaya
poins
```

Dengan probabilitas default:

```text
bahaya_chance = 0.45
poins_chance  = 0.45
```

Artinya setiap kali spawner melakukan roll:

```text
0.00 - 0.45
```

akan menghasilkan sampah berbahaya.

Kemudian:

```text
0.45 - 0.90
```

berpotensi menghasilkan sampah penghasil poin.

Sisanya tidak menghasilkan object.

Jarak spawn default:

```text
spawn_distance = 370
```

Spawner juga mempunyai dua posisi spawn sehingga posisi object tidak selalu sama.

---

# 📏 Sistem Jarak

Game memiliki sistem pengukuran jarak.

Game menyimpan jarak mentah menggunakan:

```text
raw_distance
```

Kemudian dikonversi menjadi meter menggunakan:

```text
METER_MODIFIER = 18
```

Rumusnya:

```text
meter = raw_distance / 18
```

Jarak tersebut ditampilkan pada HUD:

```text
JARAK: 100
```

Semakin lama pemain bertahan, semakin tinggi jarak yang diperoleh.

---

# ⭐ Sistem Score

Skor diperoleh melalui beberapa aktivitas.

## Mengumpulkan Sampah

Ketika pemain mengambil sampah yang termasuk:

```text
sampah_poin
```

pemain memperoleh:

```text
+10 poin
```

---

## Bonus Mini-game

Mini-game memiliki sistem bonus terpisah.

Bonus kemudian ditambahkan ke skor utama ketika mini-game selesai.

Dengan demikian:

```text
Final Score =
Main Score + Mini-game Bonus
```

---

# 🚩 Sistem Checkpoint

Checkpoint merupakan salah satu mekanik utama yang membedakan game ini dari endless runner sederhana.

Checkpoint muncul berdasarkan jarak.

Checkpoint pertama ditargetkan pada:

```text
500 meter
```

Interval checkpoint:

```text
500 meter
```

Sehingga secara konsep checkpoint muncul pada:

```text
500 m
1000 m
1500 m
2000 m
...
```

GameManager memeriksa apakah pemain sudah mencapai target:

```text
meters >= next_checkpoint_score
```

Jika kondisi terpenuhi, checkpoint diaktifkan.

---

# 🚧 Checkpoint Platform

Ketika checkpoint telah aktif, `PlatformSpawner` akan mengganti spawn platform normal berikutnya dengan:

```text
ground_checkpoint.tscn
```

Platform checkpoint mempunyai object Area2D dengan group:

```text
checkpoin
```

Ketika pemain menyentuh area tersebut, sistem checkpoint dipicu.

---

# 🪧 Checkpoint Popup

Setelah checkpoint tercapai, permainan dihentikan sementara.

Popup menampilkan pilihan:

```text
Setor sampah organik?
```

atau:

```text
Setor sampah anorganik?
```

Jenis sampah dipilih secara acak oleh GameManager:

```text
["organik", "anorganik"].pick_random()
```

Pemain kemudian mendapatkan dua pilihan.

### YES

Pemain masuk ke:

```text
Scenes/minigame.tscn
```

### NO

Popup ditutup dan permainan dilanjutkan.

---

# ♻️ Waste Sorting Mini-game

Mini-game merupakan fitur edukatif yang mengajarkan konsep pemilahan sampah.

Pada mini-game, pemain mengendalikan sebuah tempat sampah/catcher yang bergerak secara horizontal.

Pemain harus menangkap sampah yang jatuh sesuai dengan kategori yang sedang diminta.

Contohnya:

```text
TARGET:
ORGANIK
```

Pemain harus menangkap sampah organik.

Atau:

```text
TARGET:
ANORGANIK
```

Pemain harus menangkap sampah anorganik.

---

# 🗑️ Mekanik Catcher

Catcher dikendalikan dengan:

```text
←
→
```

Script:

```text
catcher.gd
```

Kecepatan default:

```text
500
```

Posisi catcher dibatasi:

```text
min_x = 50
max_x = 1100
```

Sehingga catcher tidak dapat keluar dari area permainan.

---

# ⏱️ Timer Mini-game

Mini-game memiliki batas waktu.

Selama mini-game berlangsung, HUD menampilkan:

```text
WAKTU: ...
```

Ketika timer mencapai 0:

```text
end_minigame()
```

akan dijalankan.

Bonus yang berhasil dikumpulkan kemudian ditambahkan ke skor utama.

---

# 🥬 Sistem Kategori Sampah

Mini-game menggunakan kategori:

```text
organik
anorganik
```

Beberapa variasi sampah yang tersedia antara lain:

### Organik

```text
sampah_organik_1.tscn
sampah_organik_2.tscn
sampah_organik_3.tscn
```

### Anorganik / Plastik

```text
sampah_plastik_1.tscn
sampah_plastik_2.tscn
sampah_plastik_3.tscn
```

Spawner mini-game memilih object dari daftar scene yang telah ditentukan.

---

# 🎯 Sistem Bonus Mini-game

Setiap sampah yang berhasil ditangkap memiliki konsekuensi berbeda.

## Sampah Benar

Jika:

```text
item_category == pending_trash_type
```

maka:

```text
+5 bonus
```

## Sampah Salah

Jika kategori tidak sesuai:

```text
bonus -= 10
```

Tetapi bonus tidak boleh menjadi negatif:

```text
max(0, bonus - 10)
```

Contoh:

```text
Bonus = 20
```

Menangkap sampah yang salah:

```text
20 - 10 = 10
```

Jika:

```text
Bonus = 5
```

dan menangkap sampah yang salah:

```text
max(0, 5 - 10) = 0
```

---

# 🔁 Alur Mini-game

Alur checkpoint sampai kembali ke permainan utama:

```text
Mencapai Checkpoint
        │
        ▼
Game berhenti
        │
        ▼
Checkpoint Popup
        │
        ├── NO ──────────────┐
        │                     │
        ▼                     │
       YES                    │
        │                     │
        ▼                     │
    Mini-game                 │
        │                     │
        ▼                     │
  Pilih sampah sesuai target  │
        │                     │
        ▼                     │
  Dapatkan bonus              │
        │                     │
        ▼                     │
    Timer habis               │
        │                     │
        ▼                     │
Bonus ditambahkan ke Score    │
        │                     │
        └──────────┬──────────┘
                   ▼
             World kembali
                   │
                   ▼
             Game dilanjutkan
```

---

# 🖥️ HUD

HUD menggunakan:

```text
Scenes/main/hud.tscn
```

dan:

```text
Script/hud.gd
```

Informasi yang ditampilkan:

### Score

```text
SKOR: 100
```

### Jarak

```text
JARAK: 250
```

### Nyawa

Ditampilkan menggunakan tiga icon.

### Start Information

Ketika permainan belum dimulai, HUD menampilkan informasi untuk memulai permainan.

Permainan mulai bergerak ketika pemain menekan tombol `ui_accept`.

---

# 💀 Game Over

Jika seluruh nyawa habis:

```text
hearts <= 0
```

GameManager memanggil:

```text
get_tree().call_group("world", "game_over")
```

World kemudian menjalankan:

```text
game_over()
```

Game akan dihentikan sementara dan scene Game Over ditampilkan.

Game Over menampilkan:

- Skor akhir.
- Input nama pemain.
- Tombol submit.
- Leaderboard.
- Tombol restart.

---

# 🏆 Leaderboard

Leaderboard dikelola oleh:

```text
LeaderboardManager.gd
```

Data leaderboard disimpan secara lokal menggunakan:

```text
user://leaderboard.json
```

Maksimal:

```text
10 pemain
```

Setiap skor baru:

1. Nama pemain dibersihkan dari whitespace.
2. Jika nama kosong, digunakan nama `Player`.
3. Skor ditambahkan ke daftar.
4. Data diurutkan berdasarkan skor terbesar.
5. Hanya 10 skor teratas yang disimpan.

Urutan leaderboard:

```text
Skor tertinggi
      ↓
Skor lebih rendah
      ↓
...
      ↓
Top 10
```

---

# 🧠 GameManager

GameManager merupakan pusat pengelolaan state permainan.

File:

```text
Script/autoload/GameManager.gd
```

GameManager didaftarkan sebagai **Autoload / Singleton**, sehingga dapat diakses dari berbagai scene.

Data utama yang dikelola:

```text
score
raw_distance
speed
hearts
game_running
checkpoint_zone_active
next_checkpoint_score
pending_trash_type
minigame_bonus_score
returning_from_minigame
```

---

# 🔄 State Permainan

Secara sederhana, game memiliki beberapa kondisi:

```text
INITIAL
   │
   ▼
READY
   │
   │ Space
   ▼
RUNNING
   │
   ├── Collect Trash
   │
   ├── Avoid Hazard
   │
   ├── Increase Speed
   │
   └── Reach Checkpoint
             │
             ▼
       CHECKPOINT
             │
             ├── Skip
             │
             └── Mini-game
                     │
                     ▼
                   RUNNING
                     │
                     ▼
                  GAME OVER
```

---

# 🔊 Audio Manager

Project memiliki Autoload:

```text
AudioManager
```

yang berasal dari:

```text
Script/autoload/AudioManager.gd
```

Namun pada versi project saat ini, script tersebut masih berupa struktur dasar dan belum mempunyai implementasi audio gameplay yang kompleks.

---

# 💾 Save Manager

Project juga memiliki:

```text
SaveManager
```

sebagai Autoload.

File:

```text
Script/autoload/SaveManager.gd
```

Saat ini script tersebut masih berupa struktur dasar dan belum digunakan sebagai sistem save game yang kompleks.

Leaderboard memiliki mekanisme penyimpanan sendiri menggunakan file JSON.

---

# 🧱 Struktur Project

Struktur utama project:

```text
trash-run/
│
├── Assets/
│   ├── player/
│   ├── sampah/
│   └── UI/
│       └── fonts/
│
├── Scenes/
│   ├── main.tscn
│   ├── world.tscn
│   │
│   ├── GroundVariant/
│   │   ├── ground_default.tscn
│   │   └── ground_checkpoint.tscn
│   │
│   ├── main/
│   │   ├── background.tscn
│   │   ├── checkpoint.tscn
│   │   ├── checkpoint_popup.tscn
│   │   ├── game_over.tscn
│   │   ├── hud.tscn
│   │   ├── player.tscn
│   │   │
│   │   └── sampah/
│   │       ├── sampah_berbahaya_udara.tscn
│   │       ├── sampah_kimia.tscn
│   │       ├── sampah_organik_1.tscn
│   │       └── sampah_plastik_1.tscn
│   │
│   └── minigame/
│       ├── catcher.tscn
│       ├── minigame_hud.tscn
│       └── sampah/
│           ├── sampah_organik_1.tscn
│           ├── sampah_organik_2.tscn
│           ├── sampah_organik_3.tscn
│           ├── sampah_plastik_1.tscn
│           ├── sampah_plastik_2.tscn
│           └── sampah_plastik_3.tscn
│
├── Script/
│   ├── autoload/
│   │   ├── AudioManager.gd
│   │   ├── GameManager.gd
│   │   ├── LeaderboardManager.gd
│   │   └── SaveManager.gd
│   │
│   ├── background.gd
│   ├── catcher.gd
│   ├── checkpoint_popup.gd
│   ├── falling_item.gd
│   ├── game_over.gd
│   ├── hud.gd
│   ├── item_spawner.gd
│   ├── minigame.gd
│   ├── platform.gd
│   ├── platform_spawner.gd
│   ├── player.gd
│   ├── sampah.gd
│   ├── sampah_spawner.gd
│   └── world.gd
│
├── project.godot
├── export_presets.cfg
└── icon.svg
```

---

# 🏗️ Arsitektur Scene

## Main

```text
Main
└── World
```

`main.tscn` berfungsi sebagai entry point aplikasi dan melakukan instance terhadap `world.tscn`.

---

## World

```text
World
├── Background
├── Player
├── PlatformSpawner
├── Platform
├── Platform2
├── Platform3
├── Platform4
├── HUD
├── SampahSpawner
├── GameOver
└── CheckpointPopup
```

`World` merupakan pusat gameplay utama.

---

## Mini-game

```text
Minigame
├── Background
├── Catcher
├── ItemSpawner
│   ├── Timer
│   ├── Marker1
│   ├── Marker2
│   └── Marker3
├── MinigameHUD
└── MinigameTimer
```

---

# 🔗 Komunikasi Antar Sistem

Game menggunakan **Signal** untuk menghubungkan berbagai sistem.

Contohnya GameManager memiliki signal:

```text
score_changed
distance_changed
heart_changed
checkpoint_zone_reached
checkpoint_reached
```

HUD mendengarkan perubahan tersebut.

Contoh:

```text
GameManager
     │
     ├── score_changed
     │       ↓
     │      HUD
     │
     ├── distance_changed
     │       ↓
     │      HUD
     │
     └── heart_changed
             ↓
            HUD
```

Pendekatan ini membuat HUD tidak perlu terus-menerus mencari nilai GameManager secara manual.

---

# 🔄 Alur Lengkap Permainan

Secara keseluruhan, permainan berjalan dengan alur:

```text
                    ┌───────────────┐
                    │  Main Scene   │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ World Scene   │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ Game Ready    │
                    └───────┬───────┘
                            │
                        Space
                            │
                            ▼
                    ┌───────────────┐
                    │ Endless Run   │
                    └───────┬───────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
          Hindari        Ambil         Jarak
          Sampah        Sampah        Bertambah
              │             │             │
              │           +10             │
              │                           │
              ▼                           ▼
          Kehilangan                  Checkpoint
            Nyawa                         │
              │                           ▼
              │                    Popup Checkpoint
              │                      │          │
              │                    Tidak       Ya
              │                      │          │
              │                      │          ▼
              │                      │     Mini-game
              │                      │          │
              │                      │       Bonus
              │                      │          │
              │                      └────┬─────┘
              │                           │
              │                           ▼
              │                     Lanjut Berlari
              │                           │
              └──────────────┐            │
                             ▼            │
                         Nyawa = 0        │
                             │            │
                             ▼            │
                        Game Over ◄───────┘
                             │
                             ▼
                        Submit Score
                             │
                             ▼
                         Leaderboard
```

---

# ⚙️ Parameter Gameplay Utama

Beberapa parameter penting yang digunakan project:

| Parameter | Nilai | Fungsi |
|---|---:|---|
| `START_SPEED` | 300 | Kecepatan awal |
| `MAX_SPEED` | 500 | Kecepatan maksimum |
| `GRAVITY` | 2500 | Gravitasi karakter |
| `JUMP_VELOCITY` | -1200 | Kekuatan lompatan |
| `JUMP_MULTIPLIER` | 0.8 | Pengaturan tinggi lompatan |
| `MAX_HEARTS` | 3 | Jumlah nyawa awal |
| `METER_MODIFIER` | 18 | Konversi jarak |
| `CHECKPOINT_INTERVAL` | 500 | Interval checkpoint |
| `spawn_distance` platform | 500 | Jarak spawn platform |
| `spawn_distance` sampah | 370 | Jarak spawn sampah |
| `bahaya_chance` | 0.45 | Peluang sampah berbahaya |
| `poins_chance` | 0.45 | Peluang sampah pemberi poin |
| Catcher speed | 500 | Kecepatan catcher |
| Bonus sampah benar | +5 | Bonus mini-game |
| Bonus sampah salah | -10 | Penalti mini-game |
| Sampah utama | +10 | Poin pengumpulan |

---

# 🧰 Teknologi yang Digunakan

## Godot Engine

Project dikembangkan menggunakan:

```text
Godot Engine 4.7
```

Godot digunakan untuk:

- Scene management.
- Physics.
- Collision detection.
- Animation.
- Input handling.
- UI.
- Timer.
- Signal.
- Autoload.
- Rendering.

---

## GDScript

Seluruh gameplay logic ditulis menggunakan:

```text
GDScript
```

Script dipisahkan berdasarkan tanggung jawab masing-masing object.

---

# 🧩 Konsep Pemrograman yang Digunakan

Project menerapkan beberapa konsep penting dalam pengembangan game.

### Scene-Based Architecture

Setiap komponen game dipisahkan menjadi scene:

```text
Player
HUD
World
GameOver
Checkpoint
Mini-game
Platform
Sampah
```

Hal ini membuat object lebih mudah digunakan kembali.

### Singleton / Autoload

Digunakan untuk sistem global seperti:

```text
GameManager
LeaderboardManager
AudioManager
SaveManager
```

### Signal-Based Communication

Signal digunakan untuk mengirim perubahan data:

```text
Score
Distance
Heart
Checkpoint
```

### Object Spawning

Object dibuat secara dinamis melalui:

```text
PlatformSpawner
SampahSpawner
ItemSpawner
```

### Collision Detection

Collision digunakan untuk:

- Player vs sampah.
- Player vs checkpoint.
- Catcher vs sampah mini-game.
- Player vs ground.

---

# 🚀 Cara Menjalankan Project

## 1. Install Godot

Gunakan:

```text
Godot Engine 4.7
```

Versi yang lebih baru mungkin dapat bekerja, tetapi project dikonfigurasi dan dikembangkan berdasarkan Godot 4.7.

---

## 2. Clone atau Extract Project

Pastikan struktur project tetap:

```text
trash-run/
├── project.godot
├── Scenes/
├── Script/
└── Assets/
```

File `project.godot` harus berada pada root project.

---

## 3. Import Project

Buka Godot Project Manager kemudian pilih:

```text
Import
```

dan pilih file:

```text
project.godot
```

---

## 4. Jalankan Game

Setelah project berhasil di-import:

```text
Run Project
```

atau tekan:

```text
F6
```

untuk scene tertentu dan:

```text
F5
```

untuk menjalankan project utama.

Main scene project adalah:

```text
Scenes/main.tscn
```

---

# 🐛 Catatan Implementasi

Versi project saat ini masih dalam tahap pengembangan. Beberapa sistem sudah tersedia tetapi masih dapat dikembangkan lebih lanjut.

## Leaderboard

`LeaderboardManager.gd` menyimpan data dengan struktur:

```text
name
skor
```

Namun `game_over.gd` membaca key:

```text
nama
score
```

sehingga terdapat ketidaksesuaian nama field antara proses penyimpanan dan tampilan leaderboard.

Hal ini perlu diseragamkan agar nama dan skor yang tersimpan dapat ditampilkan dengan benar.

---

## SaveManager

`SaveManager.gd` saat ini masih berupa template dasar dan belum memiliki implementasi penyimpanan progres permainan yang lengkap.

---

## AudioManager

`AudioManager.gd` juga masih berupa struktur dasar sehingga sistem audio dapat dikembangkan lebih lanjut.

---

# 🌱 Nilai Edukasi

Selain aspek hiburan, **Mandar Eco-Run** memiliki nilai edukatif mengenai pengelolaan sampah.

Melalui gameplay, pemain diperkenalkan dengan konsep:

- Sampah organik.
- Sampah anorganik.
- Sampah plastik.
- Sampah berbahaya.
- Pemilahan sampah.
- Pentingnya menjaga lingkungan.

Konsep tersebut tidak hanya disampaikan melalui teks, tetapi dimasukkan langsung ke dalam mekanik permainan.

Contohnya:

```text
Checkpoint
     ↓
Pilih jenis sampah
     ↓
Mini-game
     ↓
Pilah sampah
     ↓
Dapatkan bonus
```

Dengan pendekatan tersebut, aspek edukasi menjadi bagian dari gameplay, bukan hanya informasi tambahan.

---

# 🔮 Pengembangan Selanjutnya

Beberapa fitur yang dapat dikembangkan:

- 🎵 Background music.
- 🔊 Sound effect untuk lompatan dan collision.
- ⏸️ Pause menu.
- 🏠 Main menu.
- 🏆 Leaderboard yang lebih lengkap.
- 💾 Sistem save/load.
- 🎨 Variasi lingkungan.
- 🗑️ Lebih banyak jenis sampah.
- ♻️ Lebih banyak kategori pemilahan.
- 🎁 Power-up.
- ❤️ Item tambahan nyawa.
- 🛡️ Shield.
- ⚡ Speed boost.
- ✨ Particle effect.
- 🎬 Cutscene atau intro.
- 🥇 Achievement.
- 📊 Statistik permainan.
- 🌎 Lebih banyak area/level bertema lingkungan.
- 📱 Kontrol touch untuk perangkat mobile.

---

# 📌 Kesimpulan

**Mandar Eco-Run** merupakan game **2D Endless Runner bertema lingkungan** yang menggabungkan mekanik arcade dengan edukasi pengelolaan sampah.

Pemain harus:

> **Berlari → Menghindari sampah → Mengumpulkan sampah → Mendapatkan skor → Mencapai checkpoint → Memilah sampah → Mendapatkan bonus → Bertahan selama mungkin.**

Sistem utama game terdiri dari:

```text
Endless Runner
      +
Auto Running
      +
Jump Mechanic
      +
Obstacle
      +
Collectible
      +
Health System
      +
Score System
      +
Distance System
      +
Progressive Difficulty
      +
Checkpoint
      +
Waste Sorting Mini-game
      +
Bonus Score
      +
Game Over
      +
Leaderboard
```

Dengan kombinasi tersebut, **Mandar Eco-Run** tidak hanya berfokus pada kemampuan pemain untuk bertahan selama mungkin, tetapi juga memasukkan unsur **edukasi lingkungan melalui mekanik pemilahan sampah**.