import string
from nltk.corpus import stopwords
import enchant
import codecs
import nltk
from collections import Counter
from textstat.textstat import textstat
import math
from nltk.corpus import stopwords
from nltk.stem.porter import *
import os

stemmer = PorterStemmer()
stop = stopwords.words('english')

stoplist = stopwords.words('english')
d = enchant.Dict("en_US")

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


if not os.path.exists("essays_cleaned"):
    os.makedirs("essays_cleaned")

for id in range(1, len([name for name in os.listdir('essays')]) + 1):
    essay = read_essay("essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [stemmer.stem(word) for word in words if word[0] != '@' and d.check(word) and word not in stop]
    with codecs.open("essays_cleaned/essay_" + str(id).zfill(4) + ".txt", "w", "utf-8") as output:
        output.write(" ".join(words))

if not os.path.exists("test_essays_cleaned"):
    os.makedirs("test_essays_cleaned")

for id in range(1, len([name for name in os.listdir('test_essays')]) + 1):
    essay = read_essay("test_essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [stemmer.stem(word) for word in words if word[0] != '@' and d.check(word) and word not in stop]
    with codecs.open("test_essays_cleaned/test_essay_" + str(id).zfill(4) + ".txt", "w", "utf-8") as output:
        output.write(" ".join(words))


