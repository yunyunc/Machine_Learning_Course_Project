from movie import load_data as L


mv_lens_100k = L.load_data('100k')
user_info = mv_lens_100k.load_user_info()
movie_info = mv_lens_100k.load_movie_info()
rating_info = mv_lens_100k.load_ratings()

