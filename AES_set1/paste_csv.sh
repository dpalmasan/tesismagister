
if [ ! -f "essay_features.csv" ] ; then
  python extraer_features.py
fi

if [ ! -f "adv_giraud.csv" ] ; then
  python features_advanced_giraud.py
fi

if [ ! -f "d_estimates.csv" ] ; then
  python D_estimate.py
fi

paste -d ',' essay_features.csv adv_giraud.csv d_estimates.csv > features.csv
paste -d ',' test_essay_features.csv test_adv_giraud.csv test_d_estimates.csv > test_features.csv
