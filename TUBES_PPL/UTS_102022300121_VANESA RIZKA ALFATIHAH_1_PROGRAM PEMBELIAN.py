# Nama      : Vanesa Rizka Alfatihah
# NIM       : 102022300121
# Kelas     : SI-47-02
# No. Absen : 9

# 1. Program Pembelian

menu_0121       = ['makanan',
                   'minuman']
food_0121       = {'nasi goreng'  : 22000, 
                   'ayam goreng'  : 12000, 
                   'ayam gulai'   : 10000, 
                   'sop buntut'   : 17000, 
                   'ikan bakar'   : 11000 }
baverage_0121   = {'es teh manis' : 5000,
                   'susu coklat'  : 5000,
                   'kopi hitam'   : 5000,
                   'air mineral'  : 4000,
                   'jus jeruk'    : 7000 }
inventory_0121  = {**food_0121, **baverage_0121}
cart_0121       = []
countCart_0121  = {}
total_0121      = []

print("\n============== Rumah Makan Sederhana ==============\n")
print("Selamat datang di Rumah Makan Sederhana! \nKami menyediakan berbagai macam menu makanan dan \nminuman yang enak dengan harga terjangkau bagi \nMahasiswa Telkom University. Selamat menikmati!")

def or_0121():
    print("\n=================== Menu Utama ====================\n")
    for i_0121, option_0121 in enumerate(menu_0121, start=1):
        print(f'{i_0121}. {option_0121.capitalize()}')
    option_0121 = int(input("\nPilih opsi (1/2)\t: "))
    if option_0121 == 1:
        print("\n================== Menu Makanan ===================\n")
        for i_0121, (item_0121, price_0121) in enumerate(food_0121.items(), start=1):
            print(f'{i_0121}. {item_0121.capitalize()}\t: Rp{price_0121}')
    elif option_0121 == 2:
        print("\n================== Menu Minuman ===================\n")
        for i_0121, (item_0121, price_0121) in enumerate(baverage_0121.items(), start=1):
            print(f'{i_0121}. {item_0121.capitalize()}\t: Rp{price_0121}')
    else:
        or_0121()

def cashier_0121():
    print("\n=================== Pesan Apa? ====================\n")
    print("Anda mau beli apa? (Ketik '-' jika selesai)")
    buy_0121 = input("-> ").lower()
    while buy_0121 != '-':
        if buy_0121 in inventory_0121:
            cart_0121.append(buy_0121)
            buy_0121 = input("-> ").lower()
        else:
            print("\nMaaf, kami tidak punya itu. Ada yang lain?")
            buy_0121 = input("-> ").lower()
   
or_0121()                
cashier_0121()
or_0121()
cashier_0121()

print("\n===================== Pesanan =====================\n")
print("Inilah item yang ada di keranjang Anda: \n")

def cost_0121():
    for i_0121 in cart_0121:
        if not i_0121 in countCart_0121.keys():
            countCart_0121[i_0121] = 1
        else:
            countCart_0121[i_0121] = countCart_0121[i_0121] + 1

cost_0121()

for i_0121, (item_0121, qty_0121) in enumerate(countCart_0121.items(), start=1):
    print(f'{i_0121}. {item_0121.capitalize()}\t: {qty_0121} item')

for items_0121 in cart_0121:
    total_0121.append(inventory_0121[items_0121])
bill_0121 = sum(total_0121)

print("\n==================== Pembayaran ===================\n")
print("Total belanja Anda\t: Rp" + str(bill_0121))

if bill_0121 > 500000:
    bill_0121 = bill_0121 * (100-25)/100
    print("Diskon\t\t\t: -25%")
elif bill_0121 > 250000:
    bill_0121 = bill_0121 * (100-15)/100
    print("Diskon\t\t\t: -15%")
elif bill_0121 > 100000:
    bill_0121 = bill_0121 * (100-10)/100
    print("Diskon\t\t\t: -10%")
else:
    bill_0121 = bill_0121
    print("Diskon\t\t\t: -0%")

print("Total tagihan belanja\t: Rp" + str(bill_0121))
print("---------------------------------------------------")
input("Nama\t\t\t: ")
input("NIM\t\t\t: ")
print("---------------------------------------------------")
cash_0121 = int(input("Nominal Pembayaran\t: Rp"))
print("Jumlah kembalian Anda\t: Rp" + str(cash_0121 - bill_0121))
print("\n================== Terima Kasih ===================\n")