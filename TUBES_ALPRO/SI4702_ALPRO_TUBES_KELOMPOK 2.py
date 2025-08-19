"""
Tugas Besar: 
Aplikasi Manajemen Stok Obat

Anggota Kelompok 2:
1. Jayvero Glorify S. (102022300178) 
2. Zaky Aprilian (102022300212) 
3. Alvaritzy Maulidan R. (102022300308) 
4. Vanesa Rizka A. (102022300121)
"""

# Initialization

import os
import sqlite3
from prettytable import PrettyTable
import matplotlib.pyplot as plt

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

db_path = os.path.join(BASE_DIR, "obat.db")

conn = sqlite3.connect(db_path)

# CRUDS Function

def create_table():
    conn.execute('''CREATE TABLE IF NOT EXISTS tabel_obat (
                    id INTEGER PRIMARY KEY,
                    nama TEXT NOT NULL,
                    stok TEXT NOT NULL,
                    harga_beli INTEGER NOT NULL,
                    harga_jual INTEGER NOT NULL)''')
    conn.commit()

def read_obat():
    print('\n--- Masukkan Data Obat ---\n')
    nama        = input("Nama Obat\t: ")
    stok        = int(input("Banyak Stok\t: "))
    harga_beli  = int(input("Harga Beli\t: "))
    harga_jual  = harga_beli * 1.333

    conn.execute('''INSERT INTO tabel_obat (nama, stok, harga_beli, harga_jual) 
                    VALUES (?, ?, ?, ?)''', (nama, stok, harga_beli, harga_jual))
    conn.commit()
    print(f"\nObat '{nama}' telah ditambahkan ke dalam database.")
    
def update_obat(plus_or_minus):
    print('\n--- Update Stok Obat ---\n')
    id_update   = int(input("ID Obat\t\t: "))
    
    id_exist    = conn.execute('''
                             SELECT id FROM tabel_obat WHERE id = ?''', (id_update,)).fetchone()
    
    if id_exist:
        nama        = conn.execute('''
                                SELECT nama FROM tabel_obat WHERE id = ?''', (id_update,)).fetchone()
        
        stok_kini   = conn.execute('''
                                SELECT stok FROM tabel_obat WHERE id = ?''', (id_update,)).fetchone()
        
        if plus_or_minus == 'plus':
            stok_baru   = int(input("Tambah Stok \t: "))
            stok_update = int(stok_kini[0]) + stok_baru
        elif plus_or_minus == 'minus':
            stok_baru   = int(input("Kurangi Stok \t: "))
            stok_update = int(stok_kini[0]) - stok_baru
        
        conn.execute('''UPDATE tabel_obat
                        SET stok = ?
                        WHERE id = ?''', (stok_update, id_update))
        conn.commit()
        print(f"\nStok obat '{str(nama[0])}' telah diperbarui.")

    else:
        print(f"\nObat dengan ID {id_update} tidak ada di dalam database.")
        
def delete_obat():
    
    pass
        
def search_obat():
    view_obat('one')
    pass
    
def view_obat(all_or_one):
    if all_or_one == 'all':
        cur         = conn.execute('SELECT * FROM tabel_obat')
    elif all_or_one == 'one':
        id_search   = int(input('\nMasukkan ID Obat yang ingin dicari: '))
        cur         = conn.execute('SELECT * FROM tabel_obat WHERE id = ?', (id_search,))
        
    obat    = cur.fetchall()
    tabel   = PrettyTable(["ID", "Nama", "Stok", "Harga Beli", "Harga Jual"])

    for per_obat in obat:
        tabel.add_row(per_obat)

    print(tabel)

# Execution

create_table()

while True:
    print("\nMenu Manajemen Stok Obat:")
    menu = ["Input Obat Baru", 
            "Tambah Stok Obat", 
            "Kurangi Stok Obat",
            "Tampilkan Stok Obat",
            "Cari Obat",
            "Keluar"]
    
    for i, opsi in enumerate(menu, start=1):
        print(f"{i}. {opsi}")

    pilihan = input("\nPilih menu: ")

    if pilihan == "1":
        read_obat()
    elif pilihan == "2":
        update_obat('plus')
    elif pilihan == "3":
        update_obat('minus')
    elif pilihan == "4":
        view_obat('all')
    elif pilihan == "5":
        search_obat()
    elif pilihan == "6":
        print('\nTerima kasih! Program berakhir.\n')
        conn.close()
        break
    else:
        print("Pilihan tidak valid!")