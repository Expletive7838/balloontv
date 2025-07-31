import subprocess
import serial
import time
import sys
import os

# UART setup (adjust as needed)
UART_PORT = '/dev/serial0'
BAUD_RATE = 9600

# Frequency settings for DRA818V
TX_FREQ = '145.5000'  # Example VHF frequency
RX_FREQ = '145.5000'

# Initialize UART serial connection
ser = serial.Serial(UART_PORT, BAUD_RATE, timeout=1)

def send_at(cmd):
    full_cmd = cmd + '\r\n'
    ser.write(full_cmd.encode('utf-8'))
    time.sleep(0.3)

def configure_radio():
    send_at("AT+DMOCONNECT")
    time.sleep(0.2)
    send_at(f"AT+DMOSETGROUP=1,{TX_FREQ},{RX_FREQ},0000,0,0000")
    time.sleep(0.2)

def enable_tx():
    send_at("AT+SETGPIO=1")  # TX on
    print("[TX] Enabled")

def disable_tx():
    send_at("AT+SETGPIO=0")  # TX off
    print("[TX] Disabled")

def transmit_image(image_path):
    if not os.path.isfile(image_path):
        print(f"[Error] Image file not found: {image_path}")
        return

    print("[*] Configuring radio...")
    configure_radio()

    print("[*] Starting transmission...")
    enable_tx()

    # Run the SSTV image-to-audio bash script
    subprocess.run(["./image2wav.sh", image_path])

    # Wait briefly before ending TX
    time.sleep(0.5)
    disable_tx()
    print("[*] Transmission complete.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 sstv_transmit.py image.jpg")
        sys.exit(1)

    image_file = sys.argv[1]
    transmit_image(image_file)

