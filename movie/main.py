from movie import load_data as L
from movie import save_data as S
from movie import get_info as G
from movie import extract_feature as E

mv_lens_100k = L.load_data('100k')
user_info = mv_lens_100k.load_user_info()
movie_info = mv_lens_100k.load_movie_info()
rating_info = mv_lens_100k.load_ratings()

# year_info = G.get_year_info(movie_info)
# age_info = G.get_age_info(user_info)

data = E.extract_feature(user_info,movie_info,rating_info)

S.save_user_data(data)