import argparse
import pandas as pd
import re
from bitstring import BitArray
import numpy as np
from matplotlib import pyplot as plt

LSB = 1

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='process ila output iq csv file.')
    parser.add_argument("filePath", type=str, help="csv file path")
    parser.add_argument("--sr", type=float, help="sample rate", default=0)
    args = parser.parse_args()

    print(args.sr)

    data = pd.read_csv(args.filePath)
    q = []
    i = []
    for d in data['Q']:
        samples_in_clk = re.findall(r'\w{4}', d)  # Hex按4个字母分割是16 bits
        for sa in reversed(samples_in_clk):
            q_ = BitArray(hex=sa).int / LSB  # 转换的同时进行归一化
            q.append(q_)
    for d in data['I']:
        samples_in_clk = re.findall(r'\w{4}', d)  # Hex按4个字母分割是16 bits
        for sa in reversed(samples_in_clk):
            i_ = BitArray(hex=sa).int / LSB  # 转换的同时进行归一化
            i.append(i_)
    q = np.array(q)
    i = np.array(i)

    iq = i + 1j*q
    fs = args.sr
    n = len(iq)
    f_axis = np.arange(-n/2, (n/2)) / n*fs
    fft = 20*np.log10(np.fft.fft(iq))
    fft_p = np.fft.fftshift(np.abs(fft))
    if fs == 0:
        plt.plot(fft_p)
    else:
        plt.plot(f_axis, fft_p)
    plt.show()
