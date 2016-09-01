import math
import random
import codecs
import nltk
import functools
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error as mse
import numpy
import scipy.optimize as optimization
import os

# Lee un ensayo y retorna el texto puro
def read_essay(filename):
    with codecs.open(filename, 'r', "utf-8") as file:
        return file.read()

# Funcion auxiliar para aplicar translate a strings unicode
def translate_non_alphanumerics(to_translate, translate_to=u'_'):
	not_letters_or_digits = u'!"#%()*+,-./:;<=>?[\]^_`{|}~'
	translate_table = dict((ord(char), translate_to) for char in not_letters_or_digits)
	return to_translate.translate(translate_table)

# Reemplaza puntuacion por espacios
def strip_punctuation(text):
	return translate_non_alphanumerics(text, translate_to = u' ')

def ttr_d(N, D):
    return  D/N*((1 + 2*N/D)**(0.5)-1)

def random_ttr(tokens, random_sel):
    token_sample = random.sample(tokens, random_sel)
    return len(set(token_sample))/float(len(token_sample))

def avg_ttr(tokens, random_sel = 35, runs = 100):
    avg = 0
    for i in range(runs):
        avg += random_ttr(tokens, random_sel)
    return round(avg / runs, 3)

with codecs.open("d_estimates.csv", "w", "utf-8") as output:
    output.write("d_estimates\n")

for id in range(1, len([name for name in os.listdir('essays')]) + 1):
    essay = read_essay("essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [word for word in words if word[0] != '@']

    if len(words) >= 50:
        N = range(35, 51)
        avg_ttrs = []
        for n in N:
            avg_ttrs.append(avg_ttr(words, n, 1000))

        # Data as numpy arrays 
        xdata = numpy.array(N)
        ydata = numpy.array(avg_ttrs)
        # Initial guess
        x0 = numpy.array([1.0])

        # Data errors...
        sigma = numpy.array([1.0 for n in N])

        # Optimal D
        opt_D =  optimization.curve_fit(ttr_d, xdata, ydata, x0, sigma)[0][0]
    else:
        opt_D = float(len(words))/51 * 10.0

    with codecs.open("d_estimates.csv", "a", "utf-8") as output:
        output.write(str(opt_D) + "\n")

with codecs.open("test_d_estimates.csv", "w", "utf-8") as output:
    output.write("d_estimates\n")

for id in range(1, len([name for name in os.listdir('test_essays')]) + 1):
    essay = read_essay("test_essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [word for word in words if word[0] != '@']

    if len(words) >= 50:
        N = range(35, 51)
        avg_ttrs = []
        for n in N:
            avg_ttrs.append(avg_ttr(words, n, 1000))

        # Data as numpy arrays 
        xdata = numpy.array(N)
        ydata = numpy.array(avg_ttrs)
        # Initial guess
        x0 = numpy.array([1.0])

        # Data errors...
        sigma = numpy.array([1.0 for n in N])

        # Optimal D
        opt_D =  optimization.curve_fit(ttr_d, xdata, ydata, x0, sigma)[0][0]
    else:
        opt_D = float(len(words))/51 * 10.0

    with codecs.open("test_d_estimates.csv", "a", "utf-8") as output:
        output.write(str(opt_D) + "\n")
