import numpy as np
from scipy.io import savemat
import os

def save_user_data(data):
    data = np.asarray(data)
    FrameStack = np.empty((len(data),), dtype=np.object)
    for i in range(len(data)):
        FrameStack[i] = data[i]
    cwd = os.getcwd()
    cwd = cwd+'/movie/data.mat'
    savemat(cwd, {"FrameStack": FrameStack})