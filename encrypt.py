# Python 3 code to demonstrate the
# working of MD5 (string - hexadecimal)
import hashlib

def encrypt(str):
	result = hashlib.md5(str.encode()).hexdigest()
	return result