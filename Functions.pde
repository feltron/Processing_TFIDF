
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// TERM FREQUENCY
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

void fetch_TF(String document) {
  TFdoc = loadStrings(document);
}

void count_TF() {
  int TFwords = 0;
  TFdict = new IntDict();
  for (int i=0; i<TFdoc.length; i++) {
    // Clean text and split into words
    TFdoc[i] = clearPunctuation(TFdoc[i]);
    String[] TFdoc_words = split(TFdoc[i], ' ');
    // Add or increment TF words to dictionary
    for (int n=0; n<TFdoc_words.length; n++) {
      TFdict.add(TFdoc_words[n], 1);
      TFwords += 1;
    }
  }
  TFdict.sortValuesReverse();
  TFdictKeys = TFdict.keyArray();
  TFdictValues = TFdict.valueArray();
  TFdictValuesNormalized = new float[TFdictValues.length];
  // Normalize Term Frequency
  for (int i=0; i<TFdictValues.length; i++) {
    TFdictValuesNormalized[i] = TFdictValues[i] / float(TFwords);
  }
}

void print_TF() {
  println("\n- - - - - - - - - - - - - - - - -");
  println("TOP TERM FREQUENCY COUNTS (NORMALIZED)");
  for (int i=0; i<10; i++) {
    println(TFdictValues[i] + " - " + TFdictKeys[i] + " (x" + TFdictValuesNormalized[i] + ")");
  }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// DOCUMENT FREQUENCY
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

void fetch_DF() {
  // Get list of documents in Data Folder
  java.io.File folder = new java.io.File(dataPath(""));
  filenames = folder.list();
  for (int i=0; i<filenames.length; i++) {
    if (!filenames[i].equals("stopwords.txt")) {
      String[] DFdoc = loadStrings(filenames[i]);
      for (int n=0; n<DFdoc.length; n++) {
        DFdocs = append(DFdocs, DFdoc[n]);
      }
    }
  }
}

void count_DF() {
  DFdict = new IntDict();
  // Build empty DF dictionary with TF words
  for (int i=0; i<TFdictKeys.length; i++) {
    DFdict.set(TFdictKeys[i], 0);
  }
  // Build temporary dictionary of all terms in each document
  for (int i=0; i<DFdocs.length; i++) {
    DFdocDict = new IntDict();
    DFdocs[i] = clearPunctuation(DFdocs[i]);
    String[] DFdocs_words = split(DFdocs[i], ' ');
    for (int n=0; n<DFdocs_words.length; n++) {
      DFdocDict.increment(DFdocs_words[n]);
    }
    String[] DFdocKeys = DFdocDict.keyArray();
    int[] DFdocValues = DFdocDict.valueArray();
    for (int k=0; k<DFdocKeys.length; k++) {
      DFdict.increment(DFdocKeys[k]);
    }
  }
  DFdict.sortValuesReverse();
  DFdictKeys = DFdict.keyArray();
  DFdictValues = DFdict.valueArray();
}

void print_DF() {
  println("\n- - - - - - - - - - - - - - - - -");
  println("TOP DOCUMENT FREQUENCY COUNTS");
  for (int i=0; i<10; i++) {
    println(DFdictValues[i] + " - " + DFdictKeys[i]);
  }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// INVERSE DOCUMENT FREQUENCY
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

void compute_IDF() {
  IDFdict = new FloatDict();
  // Number of documents
  int recordCount = filenames.length-1;
  // Divide number of documents by number of documents containing each term
  for (int i=0; i<DFdictKeys.length; i++) {
    IDFdict.set(DFdictKeys[i], log10(float(recordCount)/(DFdictValues[i]+1)));
  }
  IDFdict.sortValuesReverse();
  IDFdictKeys = IDFdict.keyArray();
  IDFdictValues = IDFdict.valueArray();
}

void printTop_IDF() {
  println("\n- - - - - - - - - - - - - - - - -");
  println("TOP INVERSE DOCUMENT FREQUENCY COUNTS");
  for (int i=IDFdictKeys.length-1; i>=IDFdictKeys.length-11; i -= 1) {
    println(IDFdictValues[i] + " - " + IDFdictKeys[i]);
  }
}

void printBottom_IDF() {
  println("\n- - - - - - - - - - - - - - - - -");
  println("BOTTOM INVERSE DOCUMENT FREQUENCY COUNTS");
  for (int i=0; i<10; i++) {
    println(IDFdictValues[i] + " - " + IDFdictKeys[i]);
  }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// TERM FREQUENCY - INVERSE DOCUMENT FREQUENCY
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

void compute_TFIDF() {
  TFIDFdict = new FloatDict();
  for (int i=0; i<TFdictKeys.length; i++) {   
    float TFIDF = TFdict.get(TFdictKeys[i]) * IDFdict.get(TFdictKeys[i]);
    TFIDFdict.set(TFdictKeys[i], TFIDF);
  }
}

void clearStopWords_TFIDF() {
  stopWords = loadStrings("stopwords.txt");
  for (int i=0; i<stopWords.length; i++) {
    TFIDFdict.remove(stopWords[i]);
  }
  TFIDFdict.sortValuesReverse();
  TFIDFdictKeys = TFIDFdict.keyArray();
  TFIDFdictValues = TFIDFdict.valueArray();
}

void print_TFIDF() {
  println("\n- - - - - - - - - - - - - - - - -");
  println("TOP TERM FREQUENCY - INVERSE DOCUMENT FREQUENCY COUNTS");
  for (int i=0; i<10; i++) {
    println(TFIDFdictValues[i] + " - " + TFIDFdictKeys[i]);
  }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// SHARED FUNCTIONS
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

String clearPunctuation(String content) {
  content = content.toLowerCase();
  content = content.replace("?", "");
  content = content.replace(".", "");
  content = content.replace("!", "");
  content = content.replace(",", "");
  content = content.replace(":", "");
  content = content.replace("/", "");
  content = content.replace("(", "");
  content = content.replace(")", "");
  content = content.replace("@", "");
  content = content.replace("'", "");
  content = content.replace("\"", "");
  content = content.replace("#", "");
  content = content.replace("‘", "");
  content = content.replace("’", "");
  content = content.replace("+", "");
  content = content.replace("%", "");    
  content = content.replace("=", "");    
  content = content.replace(";", "");    
  content = content.replace("*", "");    
  content = content.replace("$", "");    
  content = content.replace("[", "");    
  content = content.replace("]", "");    
  content = content.replace(">", "");    
  content = content.replace("<", "");    
  content = content.replace("  ", " "); // convert double spaces to single
  return content;
}

float log10 (float x) {
  return (log(x) / log(10));
}

