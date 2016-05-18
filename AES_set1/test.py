import nltk
from nltk.data import load
import codecs

tagdict = load('help/tagsets/upenn_tagset.pickle')

with open("essays/1.txt", "r") as file:
   essay = file.read()

text = nltk.word_tokenize(essay)

def count_POS(essay, tagger = nltk.word_tokenize):
    global tagdict
    text = tagger(essay)
    # Dictionary for counting POS tag
    d = dict()

    # Initializing a dict with the nltk's POS tagger keys
    for key in tagdict.keys():
        d[key] = 0

    # Counting POS tags in the text
    for pair in nltk.pos_tag(text):
        if pair[1] in tagdict.keys():
            d[pair[1]] += 1
    return ",".join([str(d[key]) for key in tagdict.keys()])


with codecs.open("essays/250.txt", "r", "utf-8") as file:
    essay = file.read()
s = count_POS(essay)

