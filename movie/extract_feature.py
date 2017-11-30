occupations = ['administrator', 'artist', 'doctor', 'educator', 'engineer', 'entertainment', 'executive', 'healthcare',
               'homemaker','lawyer','librarian','marketing','none','other','programmer','retired','salesman','scientist','student',
                'technician','writer']

def extract_feature(user_info,movie_info,rating_info):
    data = []
    for user in rating_info:
        for rating in rating_info[user]:
            mv_id = rating[0]
            mv_info = extract_movie_feature(movie_info[mv_id])
            usr_info = extract_user_feature(user_info[user])
            mv_rating = [1 if rating[1]<=3 else 2]
            data.append(usr_info+mv_info+mv_rating)
    return data

def extract_user_feature(user_info):
    age = user_info['age']
    age = parse_age(age)
    gender = [1] if user_info['gender']=='M' else [2]
    occ = [occupations.index(user_info['occupation'])]+1
    return age+gender+occ


def extract_movie_feature(movie_info):
    year = movie_info['year']
    genre = movie_info['genre']
    year = parse_year(year)
    return year+genre

def parse_age(age):
    if age<=15:
        return[1]
    elif age>=16 and age<=25:
        return[2]
    elif age>=26 and age<=36:
        return[3]
    elif age>=37 and age<=57:
        return[4]
    elif age>=58:
        return[5]

def parse_year(year):
    if year >= 1997:
        return [1]
    elif year==1996:
        return [2]
    elif year==1995:
        return [3]
    elif year==1994:
        return [4]
    elif year==1993:
        return [5]
    elif year<=1992 and year>=1982:
        return [6]
    elif year<=1981 and year>=1971:
        return [7]
    elif year<=1970 and year>=1960:
        return [8]
    elif year<=1959 and year>=1940:
        return [9]
    elif year<=1939:
        return [10]