# SI-47-02 | Kelompok 9 | Tugas Besar | Aplikasi Parkir

# Vanesa Rizka Alfatihah        102022300121    
# Aisyah Nur Raihandany Putri   102022330165    
# Hana Humaira                  102022330198    
# Nabil Athalla                 102022300363    
# Anggara Rizal Febriansyah     102022300002    

# Initialization

from datetime import datetime

class ParkingSystem:
    def __init__(self, rate_per_minute):
        self.rate_per_minute    = rate_per_minute
        self.parking_records    = {}
        self.admin_pin          = "tubes0209"
        self.parking_history    = []

    # 1. Admin Parkir
    def admin_mode(self):
        try:
            pin_attempt = input("Masukkan PIN\t: ")
            if pin_attempt == self.admin_pin:
                print("\n------------ Catatan Transaksi Parkir -----------\n")
                self.view_parking_records()
                self.view_parking_history()

                while True:
                    print("\n=================== Menu Admin ==================\n")
                    print("1. Kembali ke Menu Utama")
                    print("2. Selesai")
                    admin_choice = input("\nPilih menu\t: ")

                    import sys
                
                    if admin_choice == '1':  
                        break

                    elif admin_choice == '2':
                        print("\n============== 4. Selesai =======================\n")
                        sys.exit()

                    else:
                        print("\nMaaf pilihan Anda tidak ada di menu.")
                        pass
            else:
                print("\nPIN salah. Menu Admin Parkir tidak dapat dibuka.")
                
        except Exception as e:
            print(f"\nTerdapat error pada admin_mode: {e}")

    def view_parked_car(self):
        try:
            if not self.parking_records and not self.parking_history:
                print("Maaf, data kendaraan yang parkir masih kosong.")
                return
            
            else:
                self.admin_mode()
                return
            
        except Exception as e:
            print(f"Terdapat error pada view_parked_car: {e}\n")
        
    def view_parking_records(self):
        print("-------------------------------------------------")
        for license_plate, record in self.parking_records.items():
            print(f"Pelat Kendaraan\t: {license_plate}")
            print(f"Waktu Masuk\t: {record['entry_time']}")
            print(f"Waktu Keluar\t: {record['exit_time']}")
            print("-------------------------------------------------")

    def view_parking_history(self):
        for entry in self.parking_history:
            print(f"Pelat Kendaraan\t: {entry['license_plate']}")
            print(f"Waktu Masuk\t: {entry['entry_time']}")
            print(f"Waktu Keluar\t: {entry['exit_time']}")
            print(f"Durasi Parkir\t: {entry['parked_duration']}")
            print(f"Biaya Parkir\t: Rp{int(entry['parking_fee'])}")
            print("-------------------------------------------------")

    # 2. Masuk Area Parkir
    def park_car(self, license_plate):
        if license_plate in self.parking_records:
            print("Kendaraan dengan pelat tersebut sudah terdaftar parkir.")
        else:
            entry_time = datetime.now()
            self.parking_records[license_plate] = {'entry_time': entry_time, 
                                                   'exit_time': None}
            print(f"Waktu Masuk\t: {entry_time}")

    # 3. Keluar Area Parkir
    def retrieve_car(self, license_plate):
        try: 
            if license_plate not in self.parking_records:
                print("\nKendaraan dengan pelat tersebut belum terdaftar parkir.")
            else:
                exit_time = datetime.now()
                entry_time = self.parking_records[license_plate]['entry_time']
                self.parking_records[license_plate]['exit_time'] = exit_time
                parked_duration = exit_time - entry_time
                rounded_duration = self.round_parking_duration(parked_duration)
                notrounded_duration = self.notround_parking_duration(parked_duration)
                
                print(f"Waktu Keluar\t: {exit_time}")
                print(f"Durasi Parkir\t: {parked_duration}")
                
                if notrounded_duration >= 6:
                    parking_fee = 40000
                    total_fee   = parking_fee * (100 + 25) / 100
                    print(f"Biaya Parkir\t: Rp{parking_fee}")
                    print(f"Denda Parkir\t: 25%")
                    print(f"Total Tagihan\t: Rp{total_fee}")
                elif notrounded_duration >= 4:
                    parking_fee = 40000
                    total_fee   = parking_fee * (100 + 10) / 100
                    print(f"Biaya Parkir\t: Rp{parking_fee}")
                    print(f"Denda Parkir\t: 10%")
                    print(f"Total Tagihan\t: Rp{total_fee}")
                else:
                    parking_fee = self.calculate_fee(rounded_duration)
                    total_fee   = parking_fee
                    print(f"Biaya Parkir\t: Rp{parking_fee}")
                    print(f"Denda Parkir\t: 0%")
                    print(f"Total Tagihan\t: Rp{parking_fee}")
                    
                nominal_pembayaran = int(input("Pembayaran\t: Rp"))
                print(f"Uang Kembalian\t: Rp{nominal_pembayaran - total_fee}")
                
                print("\nTerima kasih dan selamat jalan!")

                self.parking_history.append({
                    'license_plate': license_plate,
                    'entry_time': entry_time,
                    'exit_time': exit_time,
                    'parked_duration': parked_duration,
                    'parking_fee': total_fee})

                del self.parking_records[license_plate]
            
        except Exception as e:
            print(f"\nTerdapat error pada retrieve_car: {e}")

    def round_parking_duration(self, duration):
        # Pembulatan Durasi Parkir ke Atas 
        rounded_duration = int((duration.seconds + 59) // 60)
        return rounded_duration
    
    def notround_parking_duration(self, duration):
        # Pembulatan Durasi Parkir ke Bawah
        notrounded_duration = int(duration.seconds // 60)
        return notrounded_duration

    def calculate_fee(self, rounded_duration):
        # Perhitungan Biaya Parkir
        fee = rounded_duration * self.rate_per_minute
        return fee

rate_per_minute = 10000  # Rp10000 per 60 seconds
parking_system  = ParkingSystem(rate_per_minute)

# Execution

print()

while True:
    try:
        print("\n=================== Menu Utama ==================\n")
        print("1. Admin Parkir\n2. Masuk Area Parkir\n3. Keluar Area Parkir\n4. Selesai")
        choice = input("\nPilih menu\t: ")

        if choice == '1':
            print("\n============== 1. Admin Parkir ==================\n")
            
            parking_system.view_parked_car()
            
        elif choice == '2':
            print("\n============== 2. Masuk Area Parkir =============\n")
            
            license_plate = input("Pelat Kendaraan\t: ")
            parking_system.park_car(license_plate)

        elif choice == '3':
            print("\n============== 3. Keluar Area Parkir ============\n")
            
            license_plate = input("Pelat Kendaraan\t: ")
            parking_system.retrieve_car(license_plate)

        elif choice == '4':
            print("\n============== 4. Selesai =======================\n")
            break

        else:
            print("\nMaaf pilihan Anda tidak ada di menu.")
            
    except Exception as e:
            print(f"\nTerdapat error pada retrieve_car: {e}")
            
# Thank You :)