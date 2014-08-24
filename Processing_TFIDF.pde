
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// TF-IDF (Term Frequency, Inverse Document Frequency)
// Processing implementation by Nicholas Felton
// Based on python tutorial by Steven Loria
// http://stevenloria.com/finding-important-words-in-a-document-using-tf-idf/
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// FEATURES
// Calculate TF: the number of times that all terms occur in a document (or set of documents)
// Calculate IDF: divide the total number of documents by the number of documents containing the term, and then take the logarithm of that quotient
// Compute TF-IDF for all terms (the product of two statistics, term frequency and inverse document frequency)
// Filter out stop words

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// GLOBAL VARIABLES
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// Term Frequency
String[] TFdoc, TFdictKeys;
IntDict TFdict;
int[] TFdictValues;
float[] TFdictValuesNormalized;

// Document Frequency
String[] filenames, DFdictKeys;
String[] DFdocs = new String[0];
IntDict DFdict, DFdocDict;
int[] DFdictValues;

// Inverse Document Frequency
FloatDict IDFdict;
String[] IDFdictKeys;
float[] IDFdictValues;

// Term Frequency - Inverse Document Frequency
FloatDict TFIDFdict;
String[] TFIDFdictKeys;
float[] TFIDFdictValues;
String stopWords[];

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// SETUP
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
void setup() {

  // Calculate Term Frequency
  fetch_TF("document1.txt"); // Change to document2.txt or document3.txt to compare other docs
  count_TF();
  print_TF();

  // Calculate Document Frequency
  fetch_DF();
  count_DF();
  print_DF();

  // Calculate Inverse Document Frequency
  compute_IDF();
  printTop_IDF();
  printBottom_IDF();

  // Calculate Term Frequency - Inverse Document Frequency
  compute_TFIDF();
  clearStopWords_TFIDF();
  print_TFIDF();
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// DRAW
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
void draw() {
}

