import numpy as np


def fft_(iq, sample_rate):
    iq_fft = np.fft.fft(iq)
    iq_fft = np.fft.fftshift(iq_fft)
    iq_fft_log = 20*np.log10(np.abs(iq_fft))
    f_axis = np.linspace(-sample_rate/2, sample_rate/2, len(iq))
    return [f_axis, iq_fft_log]