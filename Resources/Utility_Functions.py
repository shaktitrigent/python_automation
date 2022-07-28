import random


def get_random_mail():
    num = random.randint(0, 1111)
    return 'thomas' + str(num) + '@gmail.com'
