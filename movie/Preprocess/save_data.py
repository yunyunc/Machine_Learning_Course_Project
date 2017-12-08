import numpy as np
from scipy.io import savemat
import os

def save_user_data(tr_data,te_data):
    FrameStack = np.empty((len(tr_data),), dtype=np.object)
    for i in range(len(tr_data)):
        FrameStack[i] = tr_data[i]
    cwd = os.getcwd()
    cwd = cwd+'/movie/tr_data.mat'
    savemat(cwd, {"FrameStack": FrameStack})

    FrameStack = np.empty((len(te_data),), dtype=np.object)
    for i in range(len(te_data)):
        FrameStack[i] = te_data[i]
    cwd = os.getcwd()
    cwd = cwd+'/movie/te_data.mat'
    savemat(cwd, {"FrameStack": FrameStack})