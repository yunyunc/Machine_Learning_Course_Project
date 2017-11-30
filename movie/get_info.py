def get_year_info(movie_info):
    year_info = {}
    for mv_id in movie_info:
        year = movie_info[mv_id]['year']
        if year in year_info:
            year_info[year] = year_info[year]+1
        else:
            year_info[year] = 1
    return year_info

def get_age_info(user_info):
    age_info = {}
    for user_id in user_info:
        age = user_info[user_id]['age']
        if age in age_info:
            age_info[age] = age_info[age]+1
        else:
            age_info[age] = 1
    return age_info