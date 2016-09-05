import string
from nltk.corpus import stopwords
import enchant
import codecs
import nltk
from collections import Counter
from textstat.textstat import textstat
import math
import os

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

def get_yules(tokens):
	N = len(tokens)
	tmp1 = Counter(tokens)
	tmp2 = Counter(tmp1.values())
	sum_term = sum([r**2 * tmp2[r] for r in tmp2.keys()])/float(N*N)
	sum_term -= 1/float(N)
	return 10000 * sum_term

def hapax_legomena(tokens):
	type_tokens = set(tokens)
	hapax = 0
	for token in type_tokens:
		if tokens.count(token) == 1:
			hapax += 1
	return hapax


header = "n_char,n_words,n_long_words,n_short_words,freq_word_length,avg_word_length,n_sentences"
header += ",n_long_sentences,n_short_sentences,"
header += "freq_sent_length,avg_sent_length,n_diff_words,n_stop_words,gunning_fox,flesch_reading_ease, flesch_kincaid_grade,dale_chall,"
header += "auto_read_ind,smog,lix,word_var_ratio,nominal_ratio,ttr,giraud_index,yule_k,hapax_leg,spelling_errors,"
tags_relevantes = ['CC', 'CD', 'DT', 'EX', 'IN', 'JJ', 'JJR', 'JJS', 'MD', 'NN', 'NNS', 'NNP', 'NNPS']
tags_relevantes += ['PDT', 'PRP', 'PRP$', 'RB', 'RBR', 'RBS', 'RP', 'TO', 'VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']
tags_relevantes += ['WDT', 'WP', 'WP$', 'WRB']
header += ",".join(tags_relevantes) + "\n"

with codecs.open("simple_features.csv", "w", "utf-8") as output:
    output.write(header)

for id in range(1, len([name for name in os.listdir('all_essays')]) + 1):
    essay = read_essay("all_essays/" + str(id) + ".txt")
    essay_lower = essay.lower()
    words = strip_punctuation(essay_lower).split()
    words = [word for word in words if word[0] != '@']
    sentences = nltk.tokenize.sent_tokenize(essay)

    # Lexical sophistication features
    n_char = len(essay)
    n_words = len(words)
    n_long_words = len([word for word in words if len(word) >= 6])
    n_short_words = len([word for word in words if len(word) <= 3])
    freq_word_length = Counter([len(word) for word in words]).most_common(1)[0][0]
    avg_word_length = sum([len(word) for word in words]) / float(n_words)
    n_sentences = len(sentences)
    n_long_sentences = len([sentence for sentence in sentences if len(strip_punctuation(sentence).split()) >= 15])
    n_short_sentences = len([sentence for sentence in sentences if len(strip_punctuation(sentence).split()) <= 5])
    sentences_length = [len(nltk.word_tokenize(strip_punctuation(sentence))) for sentence in sentences] # Auxiliar
    freq_sent_length = Counter(sentences_length).most_common(1)[0][0]
    avg_sent_length = sum([length for length in sentences_length])/float(n_sentences)
    n_diff_words = len(set(words))
    n_stop_words = len([word for word in words if word in nltk.corpus.stopwords.words('english')])

    # Number of each POS TAG
    tags = nltk.pos_tag(words)
    tag_count = dict()

    for tag in tags_relevantes:
        tag_count[tag] = 0

    for word,tag in tags:
        if tag in tags_relevantes:
            tag_count[tag] += 1


    # Readability Measures
    gunning_fox = textstat.gunning_fog(essay)
    flesch_reading_ease = textstat.flesch_reading_ease(essay)
    flesch_kincaid_grade = textstat.flesch_kincaid_grade(essay)
    dale_chall = textstat.dale_chall_readability_score(essay)
    auto_read_ind = textstat.automated_readability_index(essay)
    smog = textstat.smog_index(essay)
    lix = float(n_words)/n_sentences + n_long_words/float(n_words)*100.0
    word_var_ratio = math.log(n_words)/math.log(2 - math.log(len(set(words))/float(n_words)))
    noun = tag_count["NN"] + tag_count["NNS"] + tag_count["NNP"] + tag_count["NNPS"]
    prep = tag_count["IN"]
    part = tag_count["VBG"] + tag_count["VBN"]
    pro = tag_count["PRP"] + tag_count["PRP$"] + tag_count["WP$"]
    adv = tag_count["RB"] + tag_count["RBR"] + tag_count["RBS"] + tag_count["WRB"]
    v = tag_count["VB"] + tag_count["VBD"] + tag_count["VBG"] + tag_count["VBN"] + tag_count["VBP"] + tag_count["VBZ"]
    nominal_ratio = float(noun + prep + part)/(pro + adv + v)


    # Lexical diversity
    ttr = len(set(words))/float(n_words)
    giraud_index = round(len(set(words))/math.sqrt(n_words), 2)
    yule_k = get_yules(words)
    hapax_leg = hapax_legomena(words)

    spelling_errors = sum([1 for word in words if not d.check(word)])

    feat = [n_char,
    n_words,
    n_long_words,
    n_short_words,
    freq_word_length,
    avg_word_length,
    n_sentences,
    n_long_sentences,
    n_short_sentences,
    freq_sent_length,
    avg_sent_length,
    n_diff_words,
    n_stop_words,
    gunning_fox,
    flesch_reading_ease,
    flesch_kincaid_grade,
    dale_chall,
    auto_read_ind,
    smog,
    lix,
    word_var_ratio,
    nominal_ratio,
    ttr,
    giraud_index,
    yule_k,
    hapax_leg,
    spelling_errors]

    feat += [tag_count[tag] for tag in tags_relevantes]

    s = map(str, feat)
    with codecs.open("simple_features.csv", "a", "utf-8") as output:
        output.write(",".join(s) + "\n")

