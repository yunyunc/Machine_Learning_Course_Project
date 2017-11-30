import numpy as np

class load_data:

    def __init__(self, name):
        self.name = name

    def load_user_info(self):
        if self.name=='100k':
            user_info_file_name = 'data/movie/ml-100k/u.user'
            usr_info = {}
            with open(user_info_file_name,'r') as usr_info_file:
                for line in usr_info_file:
                    line = line.strip().split('|')
                    user_id = int(line[0])
                    line = self.parseUserFeature(line)
                    usr_info[user_id] = line
            return usr_info

    def load_movie_info(self):
        if self.name == '100k':
            movie_info_file_name = 'data/movie/ml-100k/u.item'
            mv_info = {}
            with open(movie_info_file_name, 'r', encoding='latin-1') as mv_info_file:
                for line in mv_info_file:
                    line = line.strip().split('|')
                    mv_id = int(line[0])
                    line = self.parseMvFeature(line)
                    mv_info[mv_id] = line
            return mv_info

    def load_ratings(self):
        if self.name == '100k':
            rating_file_name = 'data/movie/ml-100k/u.data'
            ratings = {}
            with open(rating_file_name, 'r') as rating_file:
                for line in rating_file:
                    line = line.split('\t')
                    usr_id = int(line[0])
                    if usr_id in ratings:
                        ratings[usr_id].append((int(line[1]),int(line[2])))
                    else:
                        ratings[usr_id] = [(int(line[1]),int(line[2]))]
            return ratings

    def parseUserFeature(self, line):
        age = int(line[1])
        gen = line[2]
        occ = line[3]
        return {'age':age,'gender':gen,'occupation':occ}

    def parseMvFeature(self,line):
        genres = [];
        mv_features = {}
        if line[1] == 'unknown':
            mv_features['year'] = 1800
        else:
            mv_features['year'] = int(line[2].split('-')[2])
        del line[:5]
        [genres.append(int(genre)+1) for genre in line]
        mv_features['genre'] = genres
        # mv_features['genre'] = self.parseGenre(genres)
        return mv_features

    # def parseGenre(self,genres):
    #     list_of_genres = ['unknown', 'action','adventure','animation','children','comedy','crime','documentary',
    #               'drama','fantasy','film-noir','horror','musical','mystery','romance','sci-fi','thriller',
    #               'war','western']
    #     genres = np.asarray(genres)
    #     genres = np.nonzero(genres)[0]
    #     temp = []
    #     for i in genres:
    #         temp.append(list_of_genres[i])
    #     return temp

    # def parseAge(self,age):
    #     if age<25:
    #         age_array = [1,0,0,0,0]
    #     elif age>25 and age <35:
    #         age_array = [0,1,0,0,0]
    #     elif age>35 and age<45:
    #         age_array = [0,0,1,0,0]
    #     elif age>45 and age<55:
    #         age_array = [0,0,0,1,0]
    #     else: age_array = [0,0,0,0,1]
    #     return age_array

    # def parseOcc(self,occ):
    #     occupations = ['administrator','artist','doctor','educator','engineer','entertainment','executive','healthcare','homemaker',
    #                    'lawyer','librarian','marketing','none','other','programmer','retired','salesman','scientist','student',
    #                    'technician','writer']
    #     occs = np.zeros(len(occupations))
    #     ind = occupations.index(occ)
    #     if  ind>= 0:
    #         occs[ind] = 1
    #     return list(occs.astype(int))
