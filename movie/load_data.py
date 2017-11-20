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
        occ = self.parseOcc(line[3])
        return age+gen+occ

    def parseAge(self,age):
        if age<25:
            age_array = [1,0,0,0,0]
        elif age>25 and age <35:
            age_array = [0,1,0,0,0]
        elif age>35 and age<45:
            age_array = [0,0,1,0,0]
        elif age>45 and age<55:
            age_array = [0,0,0,1,0]
        else: age_array = [0,0,0,0,1]
        return age_array

    def parseOcc(self,occ):
        occupations = ['administrator','artist','doctor','educator','engineer','entertainment','executive','healthcare','homemaker',
                       'lawyer','librarian','marketing','none','other','programmer','retired','salesman','scientist','student',
                       'technician','writer']
        occs = np.zeros(len(occupations))
        ind = occupations.index(occ)
        if  ind>= 0:
            occs[ind] = 1
        return list(occs.astype(int))

test = load_data('100k')
info = test.load_user_info()