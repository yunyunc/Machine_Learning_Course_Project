import load_data as L
import save_data as S
import get_info as G
import tr_te_split as T
import extract_feature as E

mv_lens_100k = L.load_data('100k')
user_info = mv_lens_100k.load_user_info()
movie_info = mv_lens_100k.load_movie_info()
rating_info = mv_lens_100k.load_ratings()

# year_info = G.get_year_info(movie_info)
# age_info = G.get_age_info(user_info)

data = E.extract_feature(user_info,movie_info,rating_info)

tr_data, te_data = T.tr_te_split(data)
S.save_user_data(tr_data,te_data)