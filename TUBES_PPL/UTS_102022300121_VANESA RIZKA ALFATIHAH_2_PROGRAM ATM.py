# Nama      : Vanesa Rizka Alfatihah
# NIM       : 102022300121
# Kelas     : SI-47-02
# No. Absen : 9

# 2. Program ATM

print("\n====================== ATM ======================\n")
nim_0121    = input("NIM\t\t: ")
nama_0121   = input("Nama\t\t: ")
norek_0121  = int(input("No. Rekening\t: "))
pin_0121    = input("PIN\t\t: ")
saldo_0121  = 1250000

def info_0121():
    print("NIM\t\t:", nim_0121)
    print("Nama\t\t:", nama_0121)
    print("No. Rekening\t:", norek_0121)

allowed_0121 = 3
attempt_0121 = 0

import sys

while pin_0121 != nim_0121[-6:]:
    attempt_0121 += 1
    print("\nPIN yang Anda masukkan salah! ("  + str(attempt_0121) + "/3)")
    if attempt_0121 < allowed_0121:
        pin_0121    = input("\nPIN\t\t: ")
    else:
        print("\nGawat! Anda sudah 3 kali salah memasukkan PIN!.")
        print("\n=========== Maaf, Akun Anda Terblokir ===========\n")
        sys.exit()

menu_0121 = ['cek saldo',
             'tarik uang',
             'setor uang',
             'selesai']

print("\n=================== Menu Utama ==================\n")
for i_0121, opsi_0121 in enumerate(menu_0121, start=1):
    print(f'{i_0121}. {opsi_0121.capitalize()}')

print("\n(Ketikkan angka pada menu yang dipilih.)")
select_0121 = int(input("\nPilih menu\t: "))

while select_0121 != 4:
    if select_0121 == 1:
        print("\n================= 1. Cek Saldo ==================\n")
        info_0121()
        print("Saldo\t\t: Rp" + str(saldo_0121))
        select_0121 = int(input("\nPilih menu\t: "))
    elif select_0121 == 2:
        print("\n================= 2. Tarik Uang =================\n")
        info_0121()
        kredit_0121 = int(input("Nominal kredit\t: Rp"))
        if kredit_0121 == saldo_0121:
            saldo_0121 = 0
            pass
        elif kredit_0121 > saldo_0121:
            print("\nMaaf, saldo Anda kurang.\n")
            saldo_0121 = saldo_0121
        else:
            saldo_0121 = saldo_0121 - kredit_0121
            pass
        print("Saldo akhir\t: Rp" + str(saldo_0121))
        select_0121 = int(input("\nPilih menu\t: "))
    elif select_0121 == 3:
        print("\n================= 3. Setor Uang =================\n")
        info_0121()
        debit_0121  = int(input("Nominal debit\t: Rp"))
        saldo_0121  = saldo_0121 + debit_0121
        print("Saldo akhir\t: Rp" + str(saldo_0121))
        select_0121 = int(input("\nPilih menu\t: "))
    else:
        print("\nMaaf pilihan Anda tidak ada di menu.")
        select_0121 = int(input("\nPilih menu\t: "))     
print("\n================= 4. Selesai ====================\n")