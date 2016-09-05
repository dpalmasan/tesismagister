import string
from nltk.corpus import stopwords
import enchant
import codecs
import nltk
from collections import Counter
from textstat.textstat import textstat
import math
import os

with codecs.open("1000_common_words.txt", "r", "utf-8") as input:
    common_words = input.read()

common_words = set(common_words.split())

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

def advanced_giraud(tokens, common_words):
    return sum([1 for word in tokens if word not in common_words])/math.sqrt(len(tokens))


header = "advanced_giraud\n"

with codecs.open("adv_giraud_features.csv", "w", "utf-8") as output:
    output.write(header)

for id in range(1, len([name for name in os.listdir('all_essays')]) + 1):
    essay = read_essay("all_essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [word for word in words if word[0] != '@']

    with codecs.open("adv_giraud_features.csv", "a", "utf-8") as output:
        output.write(str(advanced_giraud(words, common_words)) + "\n")

