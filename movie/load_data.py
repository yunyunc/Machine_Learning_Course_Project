from sklearn.preprocessing import OneHotEncoder
import numpy as np

class load_data:

    def __init__(self, name):
        self.name = name


    def load_user_info(self):
        if self.name=='100k':
            user_info_file_name = 'data/movie/ml-100k/u.user'
            usr_info = []
            with open(user_info_file_name,'r') as usr_info_file:
                for line in usr_info_file:
                    line = line.strip().split('|')
                    line = self.parseUserFeature(line)
                    usr_info.append(line)
            return usr_info

    def parseUserFeature(self, line):
        age = int(line[1])
        age = self.parseAge(age)
        gen = [1, 0] if line[2] == 'M' else [0, 1]
        return line

    def parseAge(self,age):
        age_array = np.zeros(5)
        if age<25:
            age_array[0] = 1
        elif age>25 and age <35:
            age_array[1] = 1;
        elif age>35 and age<45:
            age_array[2] = 1
        elif age>45 and age<55:
            age_array[3] = 1
        else: age_array[4] = 1
        return age_array




test = load_data('100k')
info = test.load_user_info()
print('haha')