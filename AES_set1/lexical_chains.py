import codecs
import numpy
import os
# Lee un ensayo y retorna el texto puro
def read_essay(filename):
	with codecs.open(filename, 'r', "utf-8") as file:
		return file.read()

def extract_feat(ftype, id, file):
  if ftype == "train":
    filename = "train_sent_bow/essay_" + str(id).zfill(4) + ".txt"
  else:
    filename = "test_sent_bow/test_essay_" + str(id).zfill(4) + ".txt"

  essay = read_essay(filename)
  lex_chains = essay.split("\n")
  lex_chains = [chain.split(" ") for chain in lex_chains]

  lengths = [len(chain) for chain in lex_chains]
  avg_len = sum(lengths) / float(len(lex_chains))
  min_len = min(lengths)
  max_len = max(lengths)
  std_len = numpy.std(numpy.array(lengths), axis=0)

  homogeinity_idx = [1 - len(set(lex_chains[i]))/float(lengths[i]) for i in range(len(lex_chains))]
  avg_hom = sum(homogeinity_idx) / float(len(lex_chains))
  min_hom = min(homogeinity_idx)
  max_hom = max(homogeinity_idx)
  std_hom = numpy.std(numpy.array(homogeinity_idx), axis=0)

  scores = [lengths[i]*homogeinity_idx[i] for i in range(len(lex_chains))]
  avg_scr = sum(scores) / float(len(scores))
  min_scr = min(scores)
  max_scr = max(scores)
  std_scr = numpy.std(numpy.array(scores), axis=0)
  file.write(str(avg_len) + "," + str(min_len) + "," + str(max_len)+ "," + str(std_len) + "," + str(avg_hom) + "," + str(min_hom)+ "," + str(max_hom) + "," + str(std_hom) + "," + str(avg_scr)+ "," + str(min_scr) + "," + str(max_scr)+ "," +str(std_scr) + "\n")

with codecs.open("lex_feat.csv", 'w', 'utf-8') as file:
  file.write("avg_len,min_len,max_len,std_len,avg_hom,min_hom,max_hom,std_hom,avg_scr,min_scr,max_scr,std_scr\n")
  for id in range(1, len([name for name in os.listdir('train_sent_bow')]) + 1):
    extract_feat("train", id, file)

with codecs.open("test_lex_feat.csv", 'w', 'utf-8') as file:
  file.write("avg_len,min_len,max_len,std_len,avg_hom,min_hom,max_hom,std_hom,avg_scr,min_scr,max_scr,std_scr\n")
  for id in range(1, len([name for name in os.listdir('test_sent_bow')]) + 1):
    extract_feat("test", id, file)  




