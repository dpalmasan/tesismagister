import string
from nltk.corpus import stopwords
import enchant
import codecs
import nltk
from collections import Counter
from textstat.textstat import textstat
import math

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

header = "word_count,long_word_count,noun_count,verb_count,comma_count,punctuation_count,"
header += "sentence_count,adjective_count,adverb_count,lexical_diversity,quotation_mark,word_length,spelling_error\n"

tags_relevantes = ['CC', 'CD', 'DT', 'EX', 'IN', 'JJ', 'JJR', 'JJS', 'MD', 'NN', 'NNS', 'NNP', 'NNPS']
tags_relevantes += ['PDT', 'PRP', 'PRP$', 'RB', 'RBR', 'RBS', 'RP', 'TO', 'VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']
tags_relevantes += ['WDT', 'WP', 'WP$', 'WRB']

with codecs.open("essay_features.csv", "w", "utf-8") as output:
    output.write(header)

for id in range(1, 1784):
    essay = read_essay("essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [word for word in words if word[0] != '@']
    sentences = nltk.tokenize.sent_tokenize(essay)

    # Number of each POS TAG
    tags = nltk.pos_tag(words)
    tag_count = dict()

    for tag in tags_relevantes:
        tag_count[tag] = 0

    for word,tag in tags:
        if tag in tags_relevantes:
            tag_count[tag] += 1	

    # Lexical sophistication features
    n_words = len(words)
    n_long_words = len([word for word in words if len(word) >= 6])
    noun = tag_count["NN"] + tag_count["NNS"] + tag_count["NNP"] + tag_count["NNPS"]
    v = tag_count["VB"] + tag_count["VBD"] + tag_count["VBG"] + tag_count["VBN"] + tag_count["VBP"] + tag_count["VBZ"]
    comma = essay.count(",")
    punct = essay.count(".")
    n_sentences = len(sentences)
    adj = tag_count["JJ"] + tag_count["JJR"] + tag_count["JJS"]
    adv = tag_count["RB"] + tag_count["RBR"] + tag_count["RBS"] + tag_count["WRB"]
    ttr = len(set(words))/float(n_words)
    quot = essay.count("?")
    avg_word_length = sum([len(word) for word in words]) / float(n_words)
    spelling_errors = sum([1 for word in words if not d.check(word)])

    feat = [
        n_words,
        n_long_words,
        noun,
        v,
        comma,
        punct,
        n_sentences,
        adj,
        adv,
        ttr,
        quot,
        avg_word_length,
        spelling_errors,
    ]

    s = map(str, feat)
    with codecs.open("essay_features.csv", "a", "utf-8") as output:
        output.write(",".join(s) + "\n")
