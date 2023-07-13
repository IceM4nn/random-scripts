#!/usr/bin/env python3
import base64
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

def decrypt(cpass):
    padding = '=' * (4 - len(cpass) % 4)
    epass = cpass + padding
    decoded = base64.b64decode(epass)
    key = b'\x4e\x99\x06\xe8\xfc\xb6\x6c\xc9\xfa\xf4\x93\x10\x62\x0f\xfe\xe8' \
          b'\xf4\x96\xe8\x06\xcc\x05\x79\x90\x20\x9b\x09\xa4\x33\xb6\x6c\x1b'
    iv = b'\x00' * 16
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
    decryptor = cipher.decryptor()
    decrypted_data = decryptor.update(decoded) + decryptor.finalize()
    return decrypted_data.decode(encoding='ascii').strip()

cpassword = "edBSHOwhZLTjt/QS9FeIcJ83mjWA98gw9guKOhJOdcqh+ZGMeXOsQbCpZ3xUjTLfCuNH8pG5aSVYdYw/NglVmQ"
print(decrypt(cpassword))