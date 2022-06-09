import argparse
import pandas as pd
import re
from bitstring import BitArray
import numpy as np
from matplotlib import pyplot as plt

LSB = 2**15

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='process ila output iq csv file.')
    parser.add_argument("filePath", type=str, help="csv file path")
    parser.add_argument("--sr", type=float, help="sample rate", default=0)
    args = parser.parse_args()

    print(args.sr)

    data = pd.read_csv(args.filePath)
    q = []
    i = []
    for d in data[r'design_1_i/QPSK_TX_on_Xband_dac0_m_axis_data_tdata1[159:0]']:
        samples_in_clk = re.findall(r'\w{4}', d)  # Hex按4个字母分割是16 bits
        is_i = True
        for sa in reversed(samples_in_clk):
            if is_i:
            	i_ = BitArray(hex=sa).int / LSB  # 转换的同时进行归一化
            	is_i = False
            	i.append(i_)
            else:
            	q_ = BitArray(hex=sa).int / LSB  # 转换的同时进行归一化
            	is_i = True
            	q.append(q_)
    q = np.array(q)
    i = np.array(i)

    plt.plot(q)
    plt.plot(i)
    plt.xlim(0,1000)
    plt.show()
