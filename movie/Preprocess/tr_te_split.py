from sklearn.model_selection import train_test_split

def tr_te_split(data):
    tr_data, te_data = train_test_split(data,test_size=0.2)
    return tr_data,te_data

