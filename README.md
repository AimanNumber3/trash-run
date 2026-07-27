# 🗑️ Trash Run

Trash Run merupakan game **2D Endless Runner** yang dikembangkan menggunakan **Godot Engine 4.7**. Pemain mengendalikan karakter yang terus berlari sambil menghindari berbagai jenis sampah sebagai rintangan. Semakin lama pemain bertahan, kecepatan permainan akan meningkat sehingga tingkat kesulitan semakin tinggi.

---

# Gameplay

1. Pemain memulai permainan dari **Main Scene**.
2. Karakter akan berlari secara otomatis.
3. Pemain menekan **Space** untuk melompat melewati rintangan.
4. Berbagai jenis sampah akan muncul secara acak.
5. Skor bertambah selama pemain bertahan hidup.
6. Jika karakter menyentuh rintangan maka permainan berakhir dan muncul layar **Game Over**.

---

# Arsitektur Scene

## Main Scene (`main.tscn`)

Entry point aplikasi.

Tugasnya hanya melakukan load terhadap `world.tscn` sehingga seluruh gameplay dipisahkan dari scene utama.

```
Main
└── World
```

---

## World Scene (`world.tscn`)

Merupakan scene inti permainan.

Scene ini bertanggung jawab mengatur hampir seluruh gameplay seperti:

* Background
* Player
* Ground
* HUD
* Platform Spawner
* Sampah Spawner
* Sistem Score
* Game State

Secara sederhana susunannya adalah:

```
World
├── Background
├── Player
├── Ground
├── HUD
├── PlatformSpawner
└── SampahSpawner
```

World juga menggunakan script `world.gd` untuk mengatur:

* memulai permainan
* update score
* meningkatkan kecepatan permainan
* menangani Game Over
* sinkronisasi antar object

---

## Background (`background.tscn`)

Mengatur tampilan latar belakang permainan.

Fungsi:

* memberi efek scrolling
* membuat permainan terasa hidup
* bergerak mengikuti kecepatan game

---

## Player (`player.tscn`)

Scene karakter utama.

Tanggung jawab:

* menerima input pemain
* melakukan lompatan
* mendeteksi tabrakan
* memicu Game Over saat mengenai obstacle

Script:

```
player.gd
```

---

## Ground (`ground_default.tscn`)

Merupakan platform tempat karakter berlari.

Ground akan dibuat secara dinamis oleh Platform Spawner sehingga permainan dapat berjalan tanpa batas (endless).

---

## Platform Spawner

Menghasilkan platform baru ketika platform lama hampir keluar dari layar.

Script:

```
platform_spawner.gd
```

Tujuan:

* membuat arena tidak pernah habis
* menghemat penggunaan memori dengan sistem spawn

---

## Sampah Spawner

Menghasilkan obstacle secara acak.

Script:

```
sampah_spawner.gd
```

Spawner akan memilih salah satu obstacle dari folder:

```
Scenes/sampah/
```

---

## Jenis Obstacle

Project ini memiliki beberapa variasi sampah sehingga permainan menjadi lebih variatif.

### Sampah Kimia

```
sampah_kimia.tscn
```

Obstacle bertema limbah kimia.

---

### Sampah Berbahaya Udara

```
sampah_berbahaya_udara.tscn
```

Obstacle bertema limbah berbahaya.

---

### Sampah Organik

```
sampah_organik_1.tscn
sampah_organik_2.tscn
sampah_organik_3.tscn
```

Memiliki beberapa variasi sprite untuk mengurangi repetisi visual.

---

### Sampah Plastik

```
sampah_plastik_1.tscn
sampah_plastik_2.tscn
sampah_plastik_3.tscn
```

Obstacle dengan variasi bentuk sampah plastik.

---

## HUD (`hud.tscn`)

Menampilkan informasi permainan seperti:

* Score
* Status permainan
* Informasi Game Over

Script:

```
hud.gd
```

---

## Game Over (`game_over.tscn`)

Scene yang muncul ketika pemain kalah.

Fitur:

* menampilkan skor
* tombol restart
* kembali ke permainan

---

# Autoload

Project menggunakan beberapa Singleton (Autoload).

## GameManager

Mengatur status permainan secara global.

Tanggung jawab:

* score
* game state
* restart

---

## AudioManager

Mengelola seluruh efek suara dan musik sehingga dapat dipanggil dari scene mana pun.

---

## SaveManager

Mengatur proses penyimpanan data permainan, misalnya high score atau konfigurasi pemain.

---

# Struktur Folder

```
Scenes/
│
├── main.tscn
├── world.tscn
├── background.tscn
├── player.tscn
├── hud.tscn
├── game_over.tscn
├── GroundVariant/
│   └── ground_default.tscn
└── sampah/
    ├── sampah_kimia.tscn
    ├── sampah_berbahaya_udara.tscn
    ├── sampah_organik_1.tscn
    ├── sampah_organik_2.tscn
    ├── sampah_organik_3.tscn
    ├── sampah_plastik_1.tscn
    ├── sampah_plastik_2.tscn
    └── sampah_plastik_3.tscn
```

---

# Alur Permainan

```
Main
    │
    ▼
World
    │
    ├── Spawn Ground
    ├── Spawn Obstacle
    ├── Player Jump
    ├── Update Score
    ├── Increase Speed
    │
    └── Collision
            │
            ▼
        Game Over
```

---

# Teknologi

* Godot Engine 4.7
* GDScript
* Singleton (Autoload)
* Scene-Based Architecture

---

# Pengembangan Selanjutnya

* High Score
* Menu Utama
* Pause Menu
* Efek Partikel
* Animasi Karakter
* Power-Up
* Leaderboard
* Audio yang lebih variatif
* Sistem Achievement
