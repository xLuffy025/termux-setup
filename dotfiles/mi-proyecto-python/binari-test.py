import datetime as dt 

now = dt.datetime.now()
h, m, s = now.hour, now.minute, now.second

def to_bin (n, bits):
    return bin(n)[2:].zfill(bits).replace("1",                  "🟩").replace("0","⬛️")

print("🕑 BINARY EMOJI CLOCK\n")
print("HOUR     :", to_bin(h, 5))
print("MIN      :", to_bin(m, 6))
print("SEC      :", to_bin(s, 6))
